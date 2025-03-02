import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseServiceProvider = Provider(
  (ref) => Supabase.instance.client,
);

final dioProvider = Provider(
  (ref) => Dio(),
);

// tables
const userTableName = "user";
const restaurentTableName = "restaurents";
const categoryTableName = "category";

// functions
const nearbyRestaurents = "nearby_restaurants";



// MENU TABLE : menu_id, restaurent_id, item_name, description, price, is_veg, actual_price, image, quantity, cuisuine, category_id, subcategory_id

// =====================
// ORDER_DETAILS TABLE: order_det_id, order_id, menu_item_id, quantity, ordered_date,

// =====================
// ORDERS TABLE: order_id, user_id, restaurent_id, order_stat, order_value, order_date

// =========================
// RESTAURANTS TABLE: restaurant_id, name, description, rating, meals_left, latitude, longitude, cuisuine, images, isActive, 
// fieldphone, pickup_time, endtime,category
// =========================

// USER TABLE: uid, phonenum, email, token, photoUrl, name, moneySaved, coSaved

// OWNERS TABLE: owner_id, restaurant_id, name, email, phone_number, profile_photo_url, is_active,
// PAYMENTS_TABLE: pay_id, order_id, payment_method, amount,



/**  Owner Table
 * 
CREATE TABLE owners (
  owner_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID REFERENCES restaurants(restaurant_id) ON DELETE CASCADE, -- Foreign key to restaurants table
  name VARCHAR(255),
  email VARCHAR(255),
  phone_number VARCHAR(20),
  profile_photo_url TEXT, -- Optional: To store owner's profile picture
  is_active BOOLEAN DEFAULT TRUE, -- Flag to indicate whether the owner is active or not
  created_at TIMESTAMP DEFAULT current_timestamp
);

 */

/**  ===================== RPC function that can be used ========================= 

(1)
To fetch restaurant for given owner: (This query will return the 
    restaurant details for the owner with specific-owner-id.)

SELECT r.*
FROM restaurants r
JOIN owners o ON r.restaurant_id = o.restaurant_id
WHERE o.owner_id = 'specific-owner-id';


(2) 
create or replace function get_orders_by_owner(owner_id UUID)
returns table (
  order_id UUID,
  user_id UUID,
  restaurant_id UUID,
  order_stat VARCHAR,
  order_value DECIMAL,
  order_date TIMESTAMP,
  item_name VARCHAR,
  quantity INT,
  ordered_date TIMESTAMP
) as $$
begin
  return query
  select o.order_id, o.user_id, o.restaurant_id, o.order_stat, o.order_value, o.order_date, 
         m.item_name, od.quantity, od.ordered_date
  from orders o
  join order_details od on o.order_id = od.order_id
  join menu m on od.menu_item_id = m.menu_id
  join owners own on o.restaurant_id = own.restaurant_id
  where own.owner_id = owner_id;
end;
$$ language plpgsql;


(3) 
create or replace function update_order_status(
  order_id UUID, 
  new_status VARCHAR
)
returns VOID as $$
begin
  update orders
  set order_stat = new_status
  where order_id = order_id;
end;
$$ language plpgsql;

(4)
create or replace function get_menu_items_by_restaurant(restaurant_id UUID)
returns table (
  menu_id UUID,
  item_name VARCHAR,
  description TEXT,
  price DECIMAL,
  is_veg BOOLEAN,
  actual_price DECIMAL,
  image TEXT,
  quantity INT,
  cuisine VARCHAR,
  category_id UUID,
  subcategory_id UUID
) as $$
begin
  return query
  select menu_id, item_name, description, price, is_veg, actual_price, image, quantity, cuisine, category_id, subcategory_id
  from menu
  where restaurant_id = restaurant_id;
end;
$$ language plpgsql;


(5)
create or replace function add_menu_item(
  restaurant_id UUID,
  item_name VARCHAR,
  description TEXT,
  price DECIMAL,
  is_veg BOOLEAN,
  actual_price DECIMAL,
  image TEXT,
  quantity INT,
  cuisine VARCHAR,
  category_id UUID,
  subcategory_id UUID
)
returns UUID as $$
declare
  new_menu_id UUID;
begin
  insert into menu (restaurant_id, item_name, description, price, is_veg, actual_price, image, quantity, cuisine, category_id, subcategory_id)
  values (restaurant_id, item_name, description, price, is_veg, actual_price, image, quantity, cuisine, category_id, subcategory_id)
  returning menu_id into new_menu_id;
  
  return new_menu_id;
end;
$$ language plpgsql;

example: 
const { data, error } = await supabase.rpc('add_menu_item', {
  restaurant_id: 'specific-restaurant-id',
  item_name: 'New Dish',
  description: 'Delicious new dish',
  price: 15.99,
  is_veg: true,
  actual_price: 12.99,
  image: 'image-url',
  quantity: 50,
  cuisine: 'Italian',
  category_id: 'category-id',
  subcategory_id: 'subcategory-id'
});

(6)
create or replace function sync_owner_with_restaurant(
  auth_user_id UUID, -- User ID from Supabase auth
  restaurant_id UUID -- Restaurant ID that the owner will manage
)
returns VOID as $$
declare
  owner_exists BOOLEAN;
begin
  -- Check if the user already has an owner record (is an owner)
  select exists(
    select 1 from owners where user_id = auth_user_id
  ) into owner_exists;

  -- If the owner doesn't exist, create a new owner record and associate with restaurant
  if not owner_exists then
    insert into owners (user_id, restaurant_id, is_active)
    values (auth_user_id, restaurant_id, TRUE);
  else
    -- If the owner exists, update their restaurant_id in case they were reassigned
    update owners
    set restaurant_id = restaurant_id
    where user_id = auth_user_id;
  end if;
end;
$$ language plpgsql;


(ADDITIONAL)
// For real time order notifications for the owners
const { data, error } = await supabase
  .from('orders')
  .on('INSERT', payload => {
    console.log('New Order:', payload.new); // Notify the restaurant owner
  })
  .eq('restaurant_id', 'specific-restaurant-id')
  .subscribe();




// Function to sign up or sign in an owner and sync them with their restaurant
async function signUpOrSignInOwner(email, password, restaurant_id) {
  try {
    // Sign in the owner (this can also be a sign-up flow)
    const { user, session, error } = await supabase.auth.signIn({ email, password });

    if (error) {
      throw new Error(error.message);
    }

    // Call the RPC to sync the owner with their restaurant
    const { data, error: rpcError } = await supabase.rpc('sync_owner_with_restaurant', {
      auth_user_id: user.id,
      restaurant_id: restaurant_id, // This would be passed when the owner logs in or signs up
    });

    if (rpcError) {
      throw new Error(rpcError.message);
    }

    console.log('Owner synced with restaurant:', data);
    return data; // Successfully synced with the restaurant
  } catch (err) {
    console.error('Error during sign-up/sign-in or syncing owner:', err.message);
    return null;
  }
}


Designing the Order Model for the Admin App
For a food ordering admin app, you need a structured approach to designing the Order and OrderDetail models. These models should capture all necessary details related to orders, including status, payment, and items ordered.

Order Model (orders Table)
This will store high-level details about each order.

js
Copy
Edit
const { DataTypes } = require("sequelize");
const sequelize = require("../db/connection"); // Assuming you have a Sequelize connection file

const Order = sequelize.define("Order", {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  totalAmount: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM("pending", "confirmed", "preparing", "delivered", "cancelled"),
    defaultValue: "pending",
  },
  paymentStatus: {
    type: DataTypes.ENUM("pending", "paid", "failed", "refunded"),
    defaultValue: "pending",
  },
  paymentMethod: {
    type: DataTypes.ENUM("cash", "card", "online"),
    allowNull: false,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
});

module.exports = Order;
Order Details Model (order_details Table)
Each order can have multiple items, so we store them separately.

js
Copy
Edit
const OrderDetail = sequelize.define("OrderDetail", {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  orderId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: "Orders",
      key: "id",
    },
  },
  productId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
  },
  price: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  subtotal: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
});

Order.hasMany(OrderDetail, { foreignKey: "orderId" });
OrderDetail.belongsTo(Order, { foreignKey: "orderId" });

module.exports = OrderDetail;
Test Cases for Orders and Order Details
1. Order Creation
✅ Should successfully create an order with valid inputs.
✅ Should fail to create an order if userId is missing.
✅ Should fail if totalAmount is not provided.
✅ Should default status to pending if not specified.

2. Order Status Update
✅ Should update order status from pending to confirmed.
✅ Should fail if trying to update status to an invalid value.
✅ Should allow updating status to cancelled if not yet delivered.

3. Order Payment
✅ Should update paymentStatus from pending to paid when payment is successful.
✅ Should not allow paymentStatus update to refunded if it's still pending.

4. Order Details Creation
✅ Should allow adding multiple items to an order.
✅ Should correctly calculate the subtotal as price * quantity.
✅ Should fail if orderId does not exist.
✅ Should fail if quantity is negative or zero.

5. Order Retrieval
✅ Should fetch all orders placed by a specific user.
✅ Should return details for a specific order, including all items.



OWNER: owner_id, restaurant_id, name, email,phone_number

RESTAURENT: restaurant_id, name, description, rating, meals_left,	 latitude, longitude, cuisuine,	 images, isActive, location, phone, pickup_time, end_time, category

MENU: menu_id, restaurent_id, item_name, description, price, is_veg, actual_price, image, text	text, quantity, cuisuine, category_id,	 subcategory_id



*/