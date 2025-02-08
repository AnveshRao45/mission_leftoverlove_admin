// import 'dart:async';

// import 'package:fade_shimmer/fade_shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:leftoverlove/core/theme/theme.dart';
// import 'package:leftoverlove/features/bottom_nav/controllers/location_controller.dart';
// import 'package:leftoverlove/route/app_router.dart';
// import 'package:leftoverlove/utils/utils.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class LocationScreen extends ConsumerWidget {
//   static const id = AppRoutes.locationScreen;
//   const LocationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Timer? debounce;
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           sbh(4.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               "Select Location",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
//             ),
//           ),
//           sbh(16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: SizedBox(
//               width: 100.w,
//               child: TextField(
//                 onChanged: (value) {
//                   if (debounce?.isActive ?? false) debounce!.cancel();
//                   debounce = Timer(const Duration(milliseconds: 500), () {
//                     // Function to execute when user stops typing
//                     if (value.length > 2) {
//                       ref.read(searchQueryProvider.notifier).state = value;
//                     }
//                   });
//                 },
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.search),
//                   hintText: 'Search for area,street',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Consumer(
//             builder: (context, ref, child) {
//               final searchQuery = ref.watch(searchQueryProvider);
//               final suggestions =
//                   ref.watch(locationSuggestionProvider(searchQuery));
//               return suggestions.when(
//                 data: (data) {
//                   if (data?.suggestions != null) {
//                     if (data!.suggestions!.isNotEmpty) {
//                       return Expanded(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: data.suggestions!.length,
//                           itemBuilder: (context, index) {
//                             final place = data.suggestions![index];
//                             return ListTile(
//                               onTap: () {
//                                 ref.read(getLocationAndUpdateProvider(
//                                     place.mapboxId!));
//                               },
//                               title: Text(place.name.toString()),
//                               subtitle: Text(place.placeFormatted.toString()),
//                               trailing: const Text(
//                                 "Select",
//                                 style: TextStyle(
//                                     color: primaryColor,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     } else {
//                       return const Center(child: Text('No places found'));
//                     }
//                   } else {
//                     return const Center(child: Text("Search for a place"));
//                   }
//                 },
//                 error: (error, stackTrace) {
//                   return const Text("error");
//                 },
//                 loading: () {
//                   return Expanded(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: 4,
//                       itemBuilder: (context, index) {
//                         return buildFadeShimmerListTile();
//                       },
//                     ),
//                   );
//                 },
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildFadeShimmerListTile() {
//     return ListTile(
//       onTap: () {},
//       title: FadeShimmer(
//         height: 16.0,
//         width: double.infinity,
//         radius: 4,
//         highlightColor: Colors.grey[200]!,
//         baseColor: Colors.grey[300]!,
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: FadeShimmer(
//           height: 14.0,
//           width: 150.0,
//           radius: 4,
//           highlightColor: Colors.grey[200]!,
//           baseColor: Colors.grey[300]!,
//         ),
//       ),
//       trailing: FadeShimmer(
//         height: 16.0,
//         width: 50.0,
//         radius: 4,
//         highlightColor: Colors.grey[200]!,
//         baseColor: Colors.grey[300]!,
//       ),
//     );
//   }
// }
