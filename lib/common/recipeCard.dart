// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hfc/models/recipe.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:cached_network_image/cached_network_image.dart';


// final nutIcons = {
//   'gluten-free': SvgPicture.asset(
//     'assets/svgs/gluten-free.svg',
//     width: 18,
//     height: 20,
//   ),
//   'keto-friendly': SvgPicture.asset(
//     'assets/svgs/keto-friendly.svg',
//     width: 18,
//     height: 20,
//   ),
//   'low-sugar': SvgPicture.asset(
//     'assets/svgs/low-sugar.svg',
//     width: 18,
//     height: 20,
//   ),
//   'paleo': SvgPicture.asset(
//     'assets/svgs/paleo.svg',
//     width: 18,
//     height: 20,
//   ),
//   'peanut-free': SvgPicture.asset(
//     'assets/svgs/peanut-free.svg',
//     width: 18,
//     height: 20,
//   ),
//   'vegan': SvgPicture.asset(
//     'assets/svgs/vegan.svg',
//     width: 18,
//     height: 20,
//   ),
//   'dairy-free': SvgPicture.asset(
//     'assets/svgs/dairy-free.svg',
//     width: 18,
//     height: 20,
//   ),
// };

// Widget buildRecipeCard(RecipeModel recipe) {
//   return Column(
//     children: [
//       recipe_image(recipe),
//       const SizedBox(
//         height: 10,
//       ),
//       recipe_title(recipe),
//       const SizedBox(
//         height: 10,
//       ),
//       //  Row(children: [
//       nutritionListBuild(recipe.getLabels()),
//       const SizedBox(
//         height: 20,
//       ),

//       //    ]),
//       Container(
//         margin: const EdgeInsets.fromLTRB(10, 0, 5, 5),
//         alignment: Alignment.topRight,
//         child: GestureDetector(
//           onTap: () async {
//             final uri = Uri.parse(recipe.url);
//             if (!await launchUrl(uri)) {
//               throw Exception('Could not launch $uri');
//             }
//           },
//           child: const Text(
//             "TO THE FULL RECIPE",
//             style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// SizedBox recipe_image(RecipeModel recipe) {
 
//   return SizedBox(
//     height: 300,
//     width: 300,
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(width: 0.5, color: Colors.indigo.shade100),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.indigo.shade200,
//             offset: const Offset(
//               5.0,
//               5.0,
//             ),
//             blurRadius: 10.0,
//             spreadRadius: 2.0,
//           ), //BoxShadow
//           const BoxShadow(
//             color: Colors.black,
//             offset: Offset(0.0, 0.0),
//             blurRadius: 0.0,
//             spreadRadius: 0.0,
//           ), //BoxShadow
//         ],

//         //<-- SEE HERE
//       ),
//       child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: CachedNetworkImage(
//           imageUrl: recipe.image,
//           placeholder: (context, url) =>
//               CircularProgressIndicator(), // Placeholder widget while loading
//           errorWidget: (context, url, error) =>
//               Icon(Icons.error), // Widget to display in case of an error
//         ),
//       ),
//     ),
//   );
// }

// Text recipe_title(RecipeModel recipe) {
//   return Text(
//     recipe.title,
//     style: const TextStyle(
//       color: Colors.black,
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//     ),
//   );
// }

// nutritionListBuild(List labels) {
//   List<Widget> nut = [];
//   for (var l in labels) {
//     switch (l) {
//       case 'Dairy-Free':
//         {
//           nut.add(
//             buildNutritionInfo('dairy-free'),
//           );
//           //  nut.add(const SizedBox(
//           //     width: 10,
//           //  ));
//         }
//         break;
//       case 'Gluten-Free':
//         {
//           nut.add(
//             buildNutritionInfo('gluten-free'),
//           );
//           //   nut.add(const SizedBox(
//           //  //   width: 10,
//           //   ));
//         }
//         break;
//       case 'Peanut-Free':
//         {
//           nut.add(
//             buildNutritionInfo('peanut-free'),
//           );
//           //   nut.add(const SizedBox(
//           // //    width: 10,
//           //   ));
//         }
//         break;
//       case 'Vegan':
//         {
//           nut.add(
//             buildNutritionInfo('vegan'),
//           );
//           //   nut.add(const SizedBox(
//           // //    width: 10,
//           //   ));
//         }
//         break;
//       case 'Paleo':
//         {
//           nut.add(
//             buildNutritionInfo('paleo'),
//           );
//           //   nut.add(const SizedBox(
//           //  //   width: 10,
//           //   ));
//         }
//         break;
//       case 'Low Sugar':
//         {
//           nut.add(
//             buildNutritionInfo('low-sugar'),
//           );
//           // nut.add(const SizedBox(
//           // //  width: 10,
//           // ));
//         }
//         break;
//       case 'Keto-Friendly':
//         {
//           nut.add(
//             buildNutritionInfo('keto-friendly'),
//           );
//           // nut.add(const SizedBox(
//           //  // width: 10,
//           // ));
//         }
//         break;
//       default:
//         {
//           //statements;
//         }
//         break;
//     }
//   }

//   return SizedBox(
//     height: 80,
//     width: 300,
//     child: GridView(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3, mainAxisExtent: 40),
//         children: nut),
//   );
// }

// Widget buildNutritionInfo(String nut) {
//   return Row(
//     children: [
//       SizedBox(
//         //     height: 20,
//         child: nutIcons[nut],
//       ),
//       Text(
//         nut,
//         style: const TextStyle(color: Colors.black, fontSize: 10),
//       )
//     ],
//   );
// }

// openUri(recipe) async {
//   final uri = Uri.parse(recipe.url);
//   if (!await launchUrl(uri)) {
//     throw Exception('Could not launch $uri');
//   }
// }
