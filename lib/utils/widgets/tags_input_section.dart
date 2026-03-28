import 'package:flutter/material.dart';

class TagsInputSection extends StatelessWidget {
  final TextEditingController inputController;
  final List<String> tags;
  final VoidCallback onAddTag;
  final void Function(String tag) onRemoveTag;
  final String labelText;
  final String hintText;

  const TagsInputSection({
    super.key,
    required this.inputController,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    this.labelText = 'Tags',
    this.hintText = 'Type tag then press Enter',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: inputController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: onAddTag,
              icon: const Icon(Icons.add),
              tooltip: 'Add tag',
            ),
          ),
          onFieldSubmitted: (_) => onAddTag(),
        ),
        const SizedBox(height: 8),
        if (tags.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => InputChip(
                      label: Text(tag),
                      onDeleted: () => onRemoveTag(tag),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
