// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';
// import 'package:mission_leftoverlove_admin/core/models/restaurent_model.dart';
// import 'package:mission_leftoverlove_admin/core/theme/theme.dart';
// import 'package:mission_leftoverlove_admin/features/bottom_nav/bottom_nav_controller.dart';
// import 'package:mission_leftoverlove_admin/features/bottom_nav/screens/home/home_screen.dart';
// import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/bottom_tag_line.dart';
// import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/food_item_card.dart';
// import 'package:mission_leftoverlove_admin/features/bottom_nav/widgets/stats_header.dart';
// import 'package:mission_leftoverlove_admin/route/app_router.dart';
// import 'package:mission_leftoverlove_admin/route/navigation.dart';
// import 'package:mission_leftoverlove_admin/utils/utils.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class RestaurentDetailScreen extends ConsumerStatefulWidget {
//   static const id = AppRoutes.restaurentDetailScreen;
//   final int restaurentId;
//   const RestaurentDetailScreen({super.key, required this.restaurentId});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _RestaurentDetailScreenState();
// }

// class _RestaurentDetailScreenState extends ConsumerState<RestaurentDetailScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     final restaurentModel = ref.read(restaurentModelProvider);

//     return Scaffold(
//       body: ref.watch(restaurentMenuProvider(widget.restaurentId)).when(
//         data: (data) {
//           debugLog("this is menu screen");
//           final restaurentMenuList = ref.watch(menueList);
//           final groupedData = groupTheData(restaurentMenuList);
//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 pinned: true,
//                 expandedHeight: 30.h,
//                 leading: const Padding(
//                   padding: EdgeInsets.only(left: 16),
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 6,
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       size: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: restaurentInfoWidget(restaurentModel),
//               ),
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   childCount:
//                       groupedData.length, // Dynamic length based on menu data
//                   (BuildContext context, int index) {
//                     final category = groupedData.keys.toList();
//                     final menuItems = groupedData.values.toList();

//                     return FoodItemCard(
//                         restaurentModel: restaurentModel,
//                         onAdd: (value) {
//                           ref.read(menueList.notifier).update(
//                                 (state) => state.map((element) {
//                                   if (element.menuId == value.menuId) {
//                                     element.selectedQuantity =
//                                         (element.selectedQuantity ?? 0) + 1;
//                                   }
//                                   return element;
//                                 }).toList(),
//                               );
//                           addFoodItemBottomSheet(value, restaurentModel);
//                         },
//                         categoryIndex: index,
//                         category: category,
//                         menuItems: menuItems);
//                   },
//                 ),
//               ),
//               const SliverToBoxAdapter(
//                 child: BottomTagLine(),
//               )
//             ],
//           );
//         },
//         error: (error, stackTrace) {
//           return Center(child: Text('Error: $error'));
//         },
//         loading: () {
//           return const Center(child: FoodItemCardShimmer());
//         },
//       ),
//     );
//   }

//   Future<void> addFoodItemBottomSheet(
//       MenuModel value, RestaurentModel restaurentModel) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             sbh(24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 "Add Item",
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//               ),
//             ),
//             sbh(4),
//             Container(
//               width: 100.w,
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [primaryColor.withOpacity(0.5), Colors.white])),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 child: Text(
//                   "Pickup timings ${formatTimeTo12Hour(restaurentModel.pickupTime!)} - ${formatTimeTo12Hour(restaurentModel.endTime!)}",
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             IndividualFoodItemCard(
//               foodItem: value,
//               showAdd: false,
//               onAdd: (menu) {},
//             ),
//             sbh(8),
//             const Divider(),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 "Just a quick note before you order: you'll need to pick up the food from the designated spot. Together, we can reduce food waste and make a positive impact!",
//                 style: TextStyle(fontWeight: FontWeight.normal),
//               ),
//             ),
//             const Spacer(),
//             const Divider(),
//             sbh(16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   IncreamentComponent(
//                     foodItem: value,
//                     quantity: value.selectedQuantity ?? 1,
//                   ),
//                   sbw(24),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         // ref.read(menueList.notifier).update(
//                         //       (state) => state.map((element) {
//                         //         if (element.menuId == value.menuId) {
//                         //           element.selectedQuantity =
//                         //               (element.selectedQuantity ?? 0) + 1;
//                         //         }
//                         //         return element;
//                         //       }).toList(),
//                         //     );
//                         Navigation.instance.pushBack();
//                       },
//                       child: Container(
//                         height: 4.h,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: primaryColor),
//                         child: Text(
//                           "Add  item ${calculatePrice(value.selectedQuantity ?? 1, value.price)}",
//                           style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             sbh(12)
//           ],
//         );
//       },
//     );
//   }

//   Widget restaurentInfoWidget(RestaurentModel restaurentModel) {
//     return Column(
//       children: [
//         ListTile(
//           minTileHeight: 0,
//           minVerticalPadding: 0,
//           title: Text(
//             restaurentModel.name!,
//             style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 overflow: TextOverflow.ellipsis),
//           ),
//           subtitle: Text(
//             restaurentModel.description!,
//             style: const TextStyle(
//                 overflow: TextOverflow.ellipsis, color: Colors.grey),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "${calculateMinutesToReach(restaurentModel.distMeters!)} mi |",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   sbw(12),
//                   Image.asset(
//                     "assets/star.png",
//                     scale: 35,
//                   ),
//                   sbw(4),
//                   Text(
//                     restaurentModel.rating.toString(),
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   sbw(12),
//                   Text(
//                     "| ${calculateKmFromMeters(
//                       restaurentModel.distMeters!,
//                     )} Kms away",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.black)),
//                 child: const Text("View Map"),
//               )
//             ],
//           ),
//         ),
//         sbh(8),
//       ],
//     );
//   }

//   Map<String, List<MenuModel>> groupTheData(List<MenuModel> menus) {
//     final Map<String, List<MenuModel>> groupData = {};

//     for (var element in menus) {
//       if (groupData.containsKey(element.subcategoryName)) {
//         // Add the element to the existing list
//         groupData[element.subcategoryName!]!.add(element);
//       } else {
//         // Initialize a new list for this subcategory and add the element
//         groupData[element.subcategoryName!] = [element];
//       }
//     }

//     return groupData;
//   }
// }

// class IncreamentComponent extends ConsumerWidget {
//   final int quantity;
//   final MenuModel foodItem;

//   const IncreamentComponent(
//       {super.key, required this.quantity, required this.foodItem});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final food = ref
//         .watch(menueList)
//         .where((element) => element.menuId == foodItem.menuId)
//         .first;
//     return Container(
//       height: 4.h,
//       padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
//       decoration: BoxDecoration(
//           border: Border.all(color: primaryColor),
//           borderRadius: BorderRadius.circular(8),
//           color: primaryColor.withOpacity(0.2)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               padding: EdgeInsets.only(bottom: 2.h),
//               onPressed: () {
//                 ref.read(menueList.notifier).update(
//                       (state) => state.map((element) {
//                         if (element.menuId == foodItem.menuId) {
//                           element.selectedQuantity =
//                               (element.selectedQuantity ?? 0) - 1;
//                         }
//                         return element;
//                       }).toList(),
//                     );
//               },
//               icon: const Icon(Icons.minimize)),
//           Text(
//             (food.selectedQuantity ?? 0).toString(),
//             style: TextStyle(fontSize: 16.sp),
//           ),
//           IconButton(
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 ref.read(menueList.notifier).update(
//                       (state) => state.map((element) {
//                         if (element.menuId == foodItem.menuId) {
//                           element.selectedQuantity =
//                               (element.selectedQuantity ?? 0) + 1;
//                         }
//                         return element;
//                       }).toList(),
//                     );
//               },
//               icon: const Icon(Icons.add))
//         ],
//       ),
//     );
//   }
// }
