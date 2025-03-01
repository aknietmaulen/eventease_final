import 'package:flutter/material.dart';
import 'package:eventease_final/models/service_provider_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SPDetailsPage extends StatelessWidget {
  final ServiceProviderModel serviceProvider;

  const SPDetailsPage({super.key, required this.serviceProvider});
  void _showFullScreenImage(BuildContext context, List<String> images, int startIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) {
        return Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              controller: PageController(initialPage: startIndex),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 1,
                    maxScale: 4,
                    child: Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceProvider.name, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF800080)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Provider Images
            // Service Provider Images (Larger + Full-Screen)
            if (serviceProvider.photos.isNotEmpty) ...[
              GestureDetector(
                onTap: () => _showFullScreenImage(context, serviceProvider.photos, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    serviceProvider.photos[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200, // ⬆ Increased height for better visibility
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (serviceProvider.photos.length > 1)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(context, serviceProvider.photos, 1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            serviceProvider.photos[1],
                            fit: BoxFit.cover,
                            height: 120, // ⬆ Increased height
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (serviceProvider.photos.length > 2)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showFullScreenImage(context, serviceProvider.photos, 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              serviceProvider.photos[2],
                              fit: BoxFit.cover,
                              height: 120, // ⬆ Increased height
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 16),
            ],


            // Service Provider Information Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceProvider.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),

                    // Price Section
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          serviceProvider.price,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Contact Section
                    Row(
                      children: [
                        Icon(Icons.phone, color:Color(0xFF800080)),
                        SizedBox(width: 6),
                        Text(
                          serviceProvider.contact,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // About the Service Provider
            Text(
              'About the Service Provider',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 8),
            Text(
              serviceProvider.description.replaceAll('- ', '\n- '),
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 24),

            // Services Section
            Text(
              'Services Offered',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: serviceProvider.services.map((service) {
                return Chip(
                  label: Text(service, style: TextStyle(fontWeight: FontWeight.w500)),
                  backgroundColor:  Color(0xFFFFD700),
                );
              }).toList(),
            ),
            SizedBox(height: 32),

            // Contact Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Uri phoneUri = Uri.parse('tel:${serviceProvider.contact}');
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Could not open phone dialer")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF800080),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Call now", style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.phone, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
