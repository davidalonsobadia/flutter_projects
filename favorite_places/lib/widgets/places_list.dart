import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/place.dart';
import 'add_place.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesListState();
  }
}

class _PlacesListState extends ConsumerState<PlacesList> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);

    Widget content = Center(
      child: Text(
        'Not places added yet.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );

    if (places.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: FileImage(places[index].image),
                      ),
                      title: Text(
                        places[index].title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                      ),
                      subtitle: Text(
                        places[index].location.address,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => PlaceDetails(places[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Places'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push<Place>(
              MaterialPageRoute(builder: ((context) => AddPlace())),
            );
          },
          icon: const Icon(Icons.add),
        ),
      ]),
      body: content,
    );
  }
}
