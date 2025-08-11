import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class ItemPhotoInput extends ConsumerWidget {
  final String? imagePath;
  final void Function()? onTap;
  const ItemPhotoInput({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.item_photo_name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(32),
            child: imagePath == null
                ? Column(
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                      Text(
                        l10n.description_upload_or_take_a_photo,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.black),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
