// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:eventease_final/providers/venue_provider.dart';  // Import your VenueProvider
// import 'package:eventease_final/models/venue_model.dart';     // Import your VenueModel

// class VenueDetailsPage extends StatelessWidget {
//   final VenueModel venueId;  // Venue ID passed when navigating to this page

//   const VenueDetailsPage({super.key, required this.venueId});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<VenueModel>(
//       future: Provider.of<VenueProvider>(context, listen: false).fetchVenueById(venueId),
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Venue Details'),
//             ),
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Venue Details'),
//             ),
//             body: Center(child: Text('Error: ${snapshot.error}')),
//           );
//         } else if (!snapshot.hasData) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Venue Details'),
//             ),
//             body: Center(child: Text('Venue not found')),
//           );
//         }

//         final venue = snapshot.data!;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(venue.name),
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//           body: SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Venue Photo
//                 Image.network(venue.photo.isNotEmpty ? venue.photo[0] : '', fit: BoxFit.cover),
//                 SizedBox(height: 16),

//                 // Venue Name
//                 Text(
//                   venue.name,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),

//                 // Venue Location
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text(
//                       venue.place,
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),

//                 // Venue Contact
//                 Row(
//                   children: [
//                     Icon(Icons.contact_phone, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text(
//                       venue.contact,
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),

//                 // Venue Description
//                 Text(
//                   'About the Venue',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   venue.description,
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 32),

//                 // Venue Categories
//                 Text(
//                   'Categories',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8.0,
//                   children: venue.category.map((cat) {
//                     return Chip(label: Text(cat));
//                   }).toList(),
//                 ),
//                 SizedBox(height: 32),

//                 // Venue Capacity and Rating
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Capacity: ${venue.capacity}',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.amber, size: 20),
//                         SizedBox(width: 4),
//                         Text(
//                           venue.rating.toStringAsFixed(1),
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 32),

//                 // Join Button or Contact Venue Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Handle venue contact or booking action
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("Contact Venue", style: TextStyle(fontSize: 16)),
//                         SizedBox(width: 8),
//                         Icon(Icons.phone),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
