import 'dart:math';

import 'package:app_button/shared/data/r.dart';
import 'package:app_button/utils/env.dart';
import 'package:app_button/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mek/mek.dart';

final class ButtonMigrations {
  static ButtonMigrations get instance => ButtonMigrations._();
  static const organizationId = 'dev';

  FirebaseFirestore get _firestore => Instances.firestore;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  ButtonMigrations._();

  Future<void> clean() async {
    lg.config('Database Cleaning...');
    await _cleanCollections({
      OrganizationsRepository.collection: {
        IngredientsRepository.collection: null,
        CategoriesRepository.collection: null,
        LevelsRepository.collection: null,
        ProductsRepository.collection: null,
        OrdersRepository.collection: {OrderItemsRepository.collection: null},
        CartsRepository.collection: {CartItemsRepository.collection: null},
      },
    });
    lg.config('Database Cleaned!');
  }

  Future<void> migrate() async {
    lg.config('Database Migrating...');

    await OrganizationsRepository.instance.save(const OrganizationDto(
      id: organizationId,
      name: 'BagniDoof',
    ));

    const firstCoursesCategory = CategoryDto(
      id: 'qis6JTiLNl0Cdfz2D0Wh',
      weight: 0,
      title: 'Primi Piatti',
    );
    const ravioliCategory = CategoryDto(
      id: '1hbbRQVurQwZ7JSAu19Z',
      weight: 1,
      title: 'Ravioli',
    );
    const drinksCategory = CategoryDto(
      id: 'J5IU4RRi5Dy5EHyfkSNL',
      weight: 2,
      title: 'Bevande',
    );
    const categories = [firstCoursesCategory, ravioliCategory, drinksCategory];

    final chickenIngredient = IngredientDto(
      id: 'koyuDvKDhL1imLcgjHr5',
      title: 'Pollo',
      description: 'Aggiunta di pollo',
      price: Decimal.parse('1.50'),
    );
    final pigIngredient = IngredientDto(
      id: 'VEI2ub9FOosr2GK6jMMc',
      title: 'Maiale',
      description: 'Aggiunta di maiale',
      price: Decimal.parse('1.50'),
    );
    final beefIngredient = IngredientDto(
      id: 'DsqZgv5vO6fKmk2e0pYV',
      title: 'Manzo',
      description: 'Pezzettini di manzo saltati in padella.',
      price: Decimal.parse('1.80'),
    );
    final shrimpsIngredient = IngredientDto(
      id: 'J4XU2yRjpaTzYzNLTRRM',
      title: 'Gamberetti',
      description: 'Aggiunta di gamberetti',
      price: Decimal.parse('1.80'),
    );
    final eggIngredient = IngredientDto(
      id: 'MV0JieRZm6GREnaUM7Ip',
      title: 'Uovo Extra',
      description: 'Aggiunta di un uovo strapazzato',
      price: Decimal.parse('0.70'),
    );
    final zuchinisIngredient = IngredientDto(
      id: 'Dw50GWoFNGuIxc1N7sMB',
      title: 'Zucchine Extra',
      description: 'Aggiunta di una porzione di zucchine',
      price: Decimal.parse('0.50'),
    );
    final carrotsIngredient = IngredientDto(
      id: '98L1YkegtKjBi1fXPY1d',
      title: 'Carote Extra',
      description: 'Aggiunta di una porzione di carote',
      price: Decimal.parse('0.50'),
    );
    final cabbageIngredient = IngredientDto(
      id: 'fL6SSIIhwD5CZ7C2Httd',
      title: 'Cavolo Extra',
      description: 'Aggiunta di una porzione di cavolo',
      price: Decimal.parse('0.50'),
    );
    final ingredients = [
      chickenIngredient,
      pigIngredient,
      beefIngredient,
      shrimpsIngredient,
      eggIngredient,
      zuchinisIngredient,
      carrotsIngredient,
      cabbageIngredient,
    ];

    const levels = [
      LevelDto(
        id: 'MYfBAEtoVzUrFQQLFxyP',
        title: 'Salsa Di Soia',
        description: '',
        min: 0,
        initial: 0,
        max: 4,
      ),
      LevelDto(
        id: 'AJaYFe7rBgt3cODa0Yec',
        title: 'Salsa Piccante',
        description: '',
        min: 0,
        initial: 0,
        max: 4,
      ),
    ];

    final productLevels = levels.map((level) => level.id).toIList();

    final random = Random();
    IList<String> resolveAddableIngredients(Iterable<IngredientDto> includedIngredients) {
      return ingredients
          .where((e) => !includedIngredients.contains(e))
          .map((e) => e.id)
          .take(random.nextInt(5) + 1)
          .toIList();
    }

    final firstCourses = [
      ProductDto(
        id: '2CEsGXmUT6GcDMhKHD7C',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, '2CEsGXmUT6GcDMhKHD7C', R.firstCoursesSpaghettiUovo),
        title: "Spaghetti all'uovo",
        description: "Spaghetti all'uovo saltati con uova e verdure di stagione.",
        price: Decimal.parse('4.10'),
        ingredients: IList([eggIngredient.id, zuchinisIngredient.id, carrotsIngredient.id]),
        removableIngredients: IList([zuchinisIngredient.id]),
        addableIngredients:
            resolveAddableIngredients([eggIngredient, zuchinisIngredient, carrotsIngredient]),
        levels: productLevels,
      ),
      ProductDto(
        id: 'eCO73liFjEGHEvIaF8QL',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'eCO73liFjEGHEvIaF8QL', R.firstCoursesSpaghettiUdon),
        title: 'Spaghetti Udon',
        description: 'Spaghetti udon saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
        ingredients: IList([eggIngredient.id, cabbageIngredient.id]),
        removableIngredients: IList([cabbageIngredient.id]),
        addableIngredients: resolveAddableIngredients([eggIngredient, cabbageIngredient]),
        levels: productLevels,
      ),
      ProductDto(
        id: 'OU54VLbMSMRnMEIme0nu',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'OU54VLbMSMRnMEIme0nu', R.firstCoursesGnocchiRiso),
        title: 'Gnocchi Di Riso',
        description: 'Gnocchi di riso saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.10'),
        ingredients: IList([eggIngredient.id, zuchinisIngredient.id]),
        removableIngredients: IList([zuchinisIngredient.id]),
        addableIngredients: resolveAddableIngredients([eggIngredient, zuchinisIngredient]),
        levels: productLevels,
      ),
      ProductDto(
        id: 'KFdKDYCv5CrdEkMPlPPY',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'KFdKDYCv5CrdEkMPlPPY', R.firstCoursesRisoCantonese),
        title: 'Riso Alla Cantonese',
        description: 'Riso saltato con uova, prosciutto cotto e piselli.',
        price: Decimal.parse('3.60'),
        ingredients: IList([eggIngredient.id]),
        removableIngredients: const IListConst([]),
        addableIngredients: resolveAddableIngredients([eggIngredient]),
        levels: productLevels,
      ),
      ProductDto(
        id: 'eOuccbWyv3hXdaQTCUxm',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'eOuccbWyv3hXdaQTCUxm', R.firstCoursesRisoVerdureMiste),
        title: 'Riso Con Verdure Miste',
        description: 'Riso saltato con uova, carote, zucchine e piselli.',
        price: Decimal.parse('3.60'),
        ingredients: IList([eggIngredient.id, carrotsIngredient.id]),
        removableIngredients: IList([carrotsIngredient.id]),
        addableIngredients: const IListConst([]),
        levels: productLevels,
      ),
      ProductDto(
        id: 'tGVLMvzKY8FpgirYVK6P',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'tGVLMvzKY8FpgirYVK6P', R.firstCoursesRisoGamberetti),
        title: 'Riso Con Gamberetti',
        description: 'Riso saltato con uova, piselli e gamberetti.',
        price: Decimal.parse('4.40'),
        ingredients: IList([eggIngredient.id, shrimpsIngredient.id]),
        removableIngredients: IList([eggIngredient.id]),
        addableIngredients: resolveAddableIngredients([eggIngredient, shrimpsIngredient]),
        levels: productLevels,
      ),
    ];

    final ravioli = [
      ProductDto(
        id: 'tIGXj4JPigpru7r1HTqT',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'tIGXj4JPigpru7r1HTqT', R.ravioliRavioliVerdure),
        title: 'Ravioli Con Verdure',
        description: 'Ravioli al vapore con ripieno alle verdure (6 pz).',
        price: Decimal.parse('3.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '3ED7ABZLejHEwVx5d9GU',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, '3ED7ABZLejHEwVx5d9GU', R.ravioliRavioliCarne),
        title: 'Ravioli Di Carne',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'n2MHLI4GfWCfPauCpigP',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'n2MHLI4GfWCfPauCpigP', R.ravioliRavioliXiaoLongBao),
        title: 'Xiao Long Bao',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'B8paUtP7m1p2LeVI9pAG',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage(
            organizationId, 'B8paUtP7m1p2LeVI9pAG', R.ravioliRavioliGamberi),
        title: 'Shao Mai',
        description: 'Ravioli al vapore con ripieno ai gamberetti (6 pz).',
        price: Decimal.parse('4.20'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
    ];

    final drinks = [
      ProductDto(
        id: 'vBTp1rEYs444Tj7Rp2pv',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Acqua Naturale',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('1.00'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'rFrsKjDdzI0HVTGruZKQ',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Acqua Frizzante',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('3.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'Ng4gG1hAu2Be2ws87D9P',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Té Al Limone',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '2CRDqwzWc9uDcgGqIyD0',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Té Alla Pesca',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'ymvsXJXFNSaFcirWYrlK',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Fanta',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'ePrNHHRjEulf10QBNo6F',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Coca Cola',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'fnIvuAG2yH50MrT9IL4w',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Redbull',
        description: 'Lattina da 25cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'LLrvqplltLs85UiGAkSw',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Moretti',
        description: 'Bottiglia da 66cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'YKMFDOi5dBCQ7NSMM1mF',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Ichnusa',
        description: 'Bottiglia da 50cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '9oik8asfD96W5JMUNzfL',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Tsingtao',
        description: 'Bottiglia da 64cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
    ];

    await Future.wait([
      _elaborate('Updating: Categories', categories.map((e) {
        return CategoriesRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: First Courses', firstCourses.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Ingredients', ingredients.map((e) {
        return IngredientsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Levels', levels.map((e) {
        return LevelsRepository.instance.save(organizationId, e);
      })),
      _elaborate('Updating: Ravioli', ravioli.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Drinks', drinks.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
    ]);
    lg.config('Database Updated!');
  }

  // Future<void> migrateToV2(String organizationId) async {
  //   await _firestore.runTransaction((tx) async {
  //     final organizationsRef = _firestore.collection(OrganizationsRepository.collection);
  //
  //     final carts = await _firestore.collection(CartsRepository.collection).get();
  //     final cartsRef = organizationsRef.doc(organizationId).collection(CartsRepository.collection);
  //     for (final cart in carts.docs) {
  //       tx.set(cartsRef.doc(cart.id), cart.data());
  //
  //       final items = await cart.reference.collection(CartItemsRepository.collection).get();
  //       final itemsRef = cart.reference.collection(CartItemsRepository.collection);
  //       for (final item in items.docs) {
  //         tx.set(itemsRef.doc(item.id), item.data());
  //       }
  //     }
  //
  //     final orders = await _firestore.collection(OrdersRepository.collection).get();
  //     final ordersRef =
  //         organizationsRef.doc(organizationId).collection(OrdersRepository.collection);
  //     for (final order in orders.docs) {
  //       tx.set(ordersRef.doc(order.id), {
  //         'organizationId': organizationId,
  //         'shippable': false,
  //         ...order.data(),
  //       });
  //       final items = await order.reference.collection(OrderItemsRepository.collection).get();
  //       final itemsRef = order.reference.collection(OrderItemsRepository.collection);
  //       for (final item in items.docs) {
  //         tx.set(itemsRef.doc(item.id), item.data());
  //       }
  //     }
  //   });
  // }

  Future<void> _cleanCollections(Map<dynamic, dynamic> collections, {String? doc}) async {
    await Future.wait(collections.entries.mapTo((collection, subCollections) async {
      final collectionRef = doc != null
          ? _firestore.doc(doc).collection(collection)
          : _firestore.collection(collection);

      final docs = await collectionRef.get();

      await Future.wait(docs.docs.map((doc) async {
        if (subCollections is Map) await _cleanCollections(subCollections, doc: doc.reference.path);

        await doc.reference.delete();
      }));
      lg.config('  ✅ ${collectionRef.path}');
    }));
  }

  Future<void> _elaborate(String name, Iterable<Future<void>> futures) async {
    lg.config(name);
    await Future.wait(futures);
  }

  Future<String> _uploadProductImage(
    String organizationId,
    String productId,
    String assetId,
  ) async {
    final prefix = Env.prefix.isEmpty ? '' : '${Env.prefix}/';
    final data = await rootBundle.load(assetId);
    final snapshot = await _storage
        .ref(
            '${prefix}organizations/$organizationId/products/$productId/${assetId.split('/').last}')
        .putData(data.buffer.asUint8List());
    return await snapshot.ref.getDownloadURL();
  }
}
