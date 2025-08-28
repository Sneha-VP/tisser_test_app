import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/item_provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routs.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> adImages = [
    "https://picsum.photos/400/200?1",
    "https://picsum.photos/400/200?2",
    "https://picsum.photos/400/200?3",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ItemProvider>(context, listen: false);
      prov.loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemProv = Provider.of<ItemProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final total = itemProv.items.length;
    final completed =
        itemProv.items.where((i) => i.status == 'completed').length;
    final pending = total - completed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            tooltip: "Logout",
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await itemProv.loadItems(forceRefresh: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 🔹 Ads Section (Carousel)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 160,
                  child: CarouselSlider(
                    items: adImages
                        .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ))
                        .toList(),
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                    ),
                  ),
                ),
              ),

              // 🔹 Stats Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                        child: _statCard("Total", total.toString(), Colors.blue)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _statCard(
                            "Completed", completed.toString(), Colors.green)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _statCard(
                            "Pending", pending.toString(), Colors.orange)),
                  ],
                ),
              ),

              // 🔹 List Section
              Builder(
                builder: (_) {
                  if (itemProv.state == LoadingState.loading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (itemProv.state == LoadingState.error) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          '⚠️ Error: ${itemProv.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else if (itemProv.items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'No items found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: itemProv.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final item = itemProv.items[idx];
                        return ItemCard(
                          item: item,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.itemDetail,
                              arguments: {'id': item.id},
                            );
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.itemEdit,
                              arguments: {'item': item},
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

      // 🔹 Floating Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.itemEdit);
        },
        backgroundColor: Colors.white, // ✅ set button color here
        icon: const Icon(Icons.add,color: Colors.green,),
        label: const Text("Add Item",style: TextStyle(color: Colors.green),),
      ),
    );
  }

  /// 🔹 Modern Stat Card
  Widget _statCard(String label, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
