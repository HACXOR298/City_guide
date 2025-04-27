import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A screen displaying detailed information about a city attraction.
class CityDesc extends StatefulWidget {
  const CityDesc({super.key});

  @override
  State<CityDesc> createState() => _CityDescState();
}

class _CityDescState extends State<CityDesc> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for fade-in effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Launches the Google Maps URL with error handling and loading state.
  Future<void> _launchMapUrl(String mapUrl) async {
    if (mapUrl.isEmpty) {
      _showErrorSnackBar('Location URL is not available.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Uri url = Uri.parse(mapUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Unable to open Google Maps. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching map: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Displays an error message using a SnackBar.
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely retrieve arguments with fallback values
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String city = arguments['city'] ?? 'Unknown City';
    final String name = arguments['name'] ?? 'Unknown Place';
    final String description = arguments['description'] ?? 'No description available.';
    final String imageUrl = arguments['image'] ?? '';
    final String locationUrl = arguments['location'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom Sliver AppBar with gradient background
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'City: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
          ),
          // Main content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image card with shadow and rounded corners
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Attraction name
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Description section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Location section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _isLoading || locationUrl.isEmpty
                                    ? null
                                    : () => _launchMapUrl(locationUrl),
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.map, color: Colors.white),
                                label: const Text(
                                  'View on Google Maps',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  disabledBackgroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}