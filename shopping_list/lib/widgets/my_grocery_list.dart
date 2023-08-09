import 'package:flutter/material.dart';

import '../data/dummy_items.dart';

class MyGroceryList extends StatelessWidget {
  const MyGroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              DecoratedBox(
                decoration:
                    BoxDecoration(color: groceryItems[index].category.color),
                child: const SizedBox(
                  width: 25,
                  height: 25,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(groceryItems[index].name),
              const Spacer(),
              Text(groceryItems[index].quantity.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
