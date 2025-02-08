// import 'package:choice/choice.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:leftoverlove/core/models/location_model.dart';
// import 'package:leftoverlove/core/services/repositories/mapbox_repo.dart';
// import 'package:leftoverlove/core/theme/theme.dart';
// import 'package:leftoverlove/features/bottom_nav/bottom_nav_controller.dart';
// import 'package:leftoverlove/features/bottom_nav/controllers/restaurent_controller.dart';
// import 'package:leftoverlove/features/bottom_nav/screens/home/location_screen.dart';
// import 'package:leftoverlove/features/bottom_nav/screens/home/restaurent_detail_screen.dart';
// import 'package:leftoverlove/features/bottom_nav/widgets/carousel_images.dart';
// import 'package:leftoverlove/features/bottom_nav/widgets/location_component.dart';
// import 'package:leftoverlove/features/bottom_nav/widgets/restaurent_card.dart';
// import 'package:leftoverlove/features/bottom_nav/widgets/stats_header.dart';
// import 'package:leftoverlove/route/navigation.dart';
// import 'package:leftoverlove/utils/utils.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             pinned: true,
//             toolbarHeight: 18.h,
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Consumer(
//                   builder: (context, ref, child) {
//                     return Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 20,
//                                   backgroundColor:
//                                       primaryColor.withOpacity(0.2),
//                                   child: const Icon(
//                                     Icons.pin_drop,
//                                     color: primaryColor,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 const LocationComponent()
//                               ],
//                             ),
//                             CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                 ref.read(globalUserModel)?.photoUrl ?? "",
//                               ),
//                             ),
//                           ],
//                         ),
//                         sbh(6),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(
//                     height: 8), // Add spacing between the title and TextField
//                 SizedBox(
//                   width: 100.w,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search for restaurent or food',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(14),
//                     bottomRight: Radius.circular(14)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                       onTap: () {
//                         ref
//                             .read(mapBoxRepoProvider)
//                             .getLocationNameWithCordinates();
//                       },
//                       child: const StatsHeader()),
//                   sbh(12),
//                   const CarouselImageWidet(images: [
//                     "https://img.freepik.com/free-psd/food-menu-restaurant-web-banner-cover-template-design_84443-10576.jpg?t=st=1735068470~exp=1735072070~hmac=f9994af0904cd64e90d4558993fe0363cd0d162081122b7faf00c3870633a62f&w=1380",
//                     "https://img.freepik.com/free-psd/food-menu-restaurant-web-banner-cover-template-design_84443-10576.jpg?t=st=1735068470~exp=1735072070~hmac=f9994af0904cd64e90d4558993fe0363cd0d162081122b7faf00c3870633a62f&w=1380",
//                     "https://img.freepik.com/free-psd/food-menu-restaurant-web-banner-cover-template-design_84443-10576.jpg?t=st=1735068470~exp=1735072070~hmac=f9994af0904cd64e90d4558993fe0363cd0d162081122b7faf00c3870633a62f&w=1380"
//                   ]),
//                   sbh(12),
//                 ],
//               ),
//             ),
//           ),
//           SliverPersistentHeader(
//               pinned: true, delegate: TabBarHeaderDelegate()),
//           SliverFixedExtentList(
//             itemExtent: 28.h,
//             delegate: SliverChildBuilderDelegate(
//               childCount: ref.watch(loadingStateProvider)
//                   ? 2
//                   : ref
//                       .read(bottomNavRef)
//                       .getFilteredRestaurants(
//                         ref.watch(restaurents).values.toList(),
//                         ref.watch(filterChipProvider),
//                       )
//                       .length,
//               (BuildContext context, int index) {
//                 return Consumer(
//                   builder: (context, ref, child) {
//                     final allrestaurents =
//                         ref.watch(restaurents).values.toList();
//                     final filters = ref.watch(filterChipProvider);
//                     final loadingState = ref.watch(loadingStateProvider);
//                     final restaurant =
//                         ref.read(bottomNavRef).getFilteredRestaurants(
//                               allrestaurents,
//                               filters,
//                             );
//                     return loadingState
//                         ? const RestuarentCardShimmer()
//                         : RestuarentCard(
//                             onTap: () {
//                               ref.read(restaurentModelProvider.notifier).update(
//                                     (state) => restaurant[index],
//                                   );
//                               final restaurentId =
//                                   restaurant[index].restaurantId;
//                               Navigation.instance.navigateTo(
//                                   RestaurentDetailScreen.id.path,
//                                   args: restaurentId);
//                             },
//                             restaurentModel: restaurant[
//                                 index]); // Pass the data to your card
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LocationWarningHeader extends ConsumerWidget {
//   final LocationModel locationModel;
//   const LocationWarningHeader({
//     super.key,
//     required this.locationModel,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return locationModel.locationName == "West maredpally, secunderabad"
//         ? Container(
//             decoration: BoxDecoration(
//                 color: primaryColor.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(12)),
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             width: 100.w,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Warning",
//                       style: TextStyle(
//                           fontSize: 16.sp, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "You have not given location permission",
//                       style: TextStyle(
//                           fontSize: 14.sp, fontWeight: FontWeight.w400),
//                     )
//                   ],
//                 ),
//                 TextButton(onPressed: () {}, child: const Text("Enable"))
//               ],
//             ),
//           )
//         : const SizedBox();
//   }
// }

// class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
//   TabBarHeaderDelegate();

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Consumer(
//       builder: (context, ref, child) {
//         return ref.watch(categoriesFutureProvider).when(
//           data: (data) {
//             final selectedFilters = ref.watch(filterChipProvider);

//             return Container(
//               alignment: Alignment.center,
//               color: Colors.white,
//               height: 100, // This should match maxExtent and minExtent
//               child: InlineChoice<String>.multiple(
//                 clearable: true,
//                 itemCount: data.length,
//                 value: selectedFilters,
//                 onChanged: (value) async {
//                   ref.read(filterChipProvider.notifier).update(
//                         (state) => value,
//                       );
//                   ref.read(loadingStateProvider.notifier).update(
//                         (state) => true,
//                       );
//                   await Future.delayed(const Duration(seconds: 1));
//                   ref.read(loadingStateProvider.notifier).update(
//                         (state) => false,
//                       );
//                 },
//                 itemBuilder: (state, i) {
//                   return ChoiceChip(
//                     selected: state.selected(data[i]),
//                     onSelected: state.onSelected(data[i]),
//                     label: Text(data[i]),
//                   );
//                 },
//                 listBuilder: ChoiceList.createScrollable(
//                     spacing: 10,
//                     padding: const EdgeInsets.symmetric(horizontal: 16)),
//               ),
//             );
//           },
//           error: (error, stackTrace) {
//             return Text('Error: $error');
//           },
//           loading: () {
//             return const Center(
//               child: Text("Loading"),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   double get maxExtent => 100; // Adjusted to match content height

//   @override
//   double get minExtent => 100; // Adjusted to match content height

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// class FilterComponent extends ConsumerWidget {
//   const FilterComponent({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CircleAvatar(
//       radius: 22,
//       backgroundColor: primaryColor.withOpacity(0.5),
//       child: Image.asset(
//         "assets/filter.png",
//         scale: 16,
//       ),
//     );
//   }
// }
