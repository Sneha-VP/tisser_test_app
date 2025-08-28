import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../routes/app_routs.dart';
import '../widgets/item_card.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});
  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ItemProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: prov.state == LoadingState.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: prov.items.length,
              itemBuilder: (ctx, idx) {
                final item = prov.items[idx];
                return ItemCard(
                  item: item,
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.itemDetail,
                      arguments: {'id': item.id}),
                  onEdit: () => Navigator.pushNamed(context, AppRoutes.itemEdit,
                      arguments: {'item': item}),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.itemEdit),
        child: const Icon(Icons.add),
      ),
    );
  }
}
