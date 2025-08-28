import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().add_Hm().format(item.createdDate);

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(item.title),
        subtitle: Text(
          '${item.description}\n$dateStr',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          height: 60, // enough space for both widgets
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fixed width status "button"
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: item.status == 'completed'
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.edit, size: 18),
              //   onPressed: onEdit,
              //   padding: EdgeInsets.zero, // remove extra padding
              //   constraints: const BoxConstraints(), // shrink button size
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
