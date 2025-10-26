import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/AppLocalizations.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeDetailScreen.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeModel.dart';

class SchemeCard extends StatelessWidget {
  final SchemeModel scheme;

  const SchemeCard({Key? key, required this.scheme}) : super(key: key);

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'agriculture':
        return const Color(0xFF10B981);
      case 'education':
        return const Color(0xFF3B82F6);
      case 'health':
        return const Color(0xFFEF4444);
      case 'housing':
        return const Color(0xFFF97316);
      case 'social welfare':
        return const Color(0xFF8B5CF6);
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'agriculture':
        return Icons.agriculture;
      case 'education':
        return Icons.school;
      case 'health':
        return Icons.local_hospital;
      case 'housing':
        return Icons.home;
      case 'social welfare':
        return Icons.people;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(scheme.category);
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: categoryColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchemeDetailScreen(scheme: scheme),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, categoryColor.withOpacity(0.03)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withOpacity(0.2),
                            categoryColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(scheme.category),
                        color: categoryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000080),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              scheme.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  scheme.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: const Color(0xFFF97316),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        scheme.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF000080),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF97316), Color(0xFFEF4444)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SchemeDetailScreen(scheme: scheme),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: Text(l10n.readMore),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
