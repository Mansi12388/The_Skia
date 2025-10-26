
import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/AppLocalizations.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/LanguageProvider.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeCard.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeProvider.dart';
import 'package:provider/provider.dart';

class SchemeListScreen extends StatefulWidget {
  const SchemeListScreen({Key? key}) : super(key: key);

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchemeProvider>().loadSchemes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/Nss_Logo.jpg",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF000080), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        actions: [_buildLanguageSelector()],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildSchemeList()),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      tooltip: 'Change Language',
      onSelected: (Locale locale) {
        context.read<LanguageProvider>().setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        final langProvider = context.read<LanguageProvider>();
        return [
          PopupMenuItem(
            value: const Locale('en'),
            child: Row(
              children: [
                if (langProvider.locale.languageCode == 'en')
                  const Icon(Icons.check, color: Color(0xFFF97316), size: 20),
                if (langProvider.locale.languageCode == 'en')
                  const SizedBox(width: 8),
                Text(langProvider.getLanguageName('en')),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('mr'),
            child: Row(
              children: [
                if (langProvider.locale.languageCode == 'mr')
                  const Icon(Icons.check, color: Color(0xFFF97316), size: 20),
                if (langProvider.locale.languageCode == 'mr')
                  const SizedBox(width: 8),
                Text(langProvider.getLanguageName('mr')),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('hi'),
            child: Row(
              children: [
                if (langProvider.locale.languageCode == 'hi')
                  const Icon(Icons.check, color: Color(0xFFF97316), size: 20),
                if (langProvider.locale.languageCode == 'hi')
                  const SizedBox(width: 8),
                Text(langProvider.getLanguageName('hi')),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildSearchBar() {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000080), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            context.read<SchemeProvider>().setSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: l10n.search,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFF97316)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFF97316)),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SchemeProvider>().setSearchQuery('');
                      setState(() {}); // Rebuild to hide clear button
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final l10n = AppLocalizations.of(context);

    return Consumer<SchemeProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = provider.selectedCategory == category;

              String categoryText = category;
              switch (category) {
                case 'All':
                  categoryText = l10n.all;
                  break;
                case 'Agriculture':
                  categoryText = l10n.agriculture;
                  break;
                case 'Education':
                  categoryText = l10n.education;
                  break;
                case 'Health':
                  categoryText = l10n.health;
                  break;
                case 'Housing':
                  categoryText = l10n.housing;
                  break;
                case 'Social Welfare':
                  categoryText = l10n.socialWelfare;
                  break;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ChoiceChip(
                  label: Text(categoryText),
                  selected: isSelected,
                  onSelected: (selected) {
                    provider.setCategory(category);
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: const Color(0xFFF97316),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: isSelected ? 4 : 0,
                  shadowColor: const Color(0xFFF97316).withOpacity(0.3),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSchemeList() {
    final l10n = AppLocalizations.of(context);

    return Consumer<SchemeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.loading,
                  style: const TextStyle(
                    color: Color(0xFF000080),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      l10n.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.loadSchemes(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      l10n.retry,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.schemes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  l10n.noSchemes,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFF97316),
          onRefresh: () => provider.loadSchemes(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.schemes.length,
            itemBuilder: (context, index) {
              return SchemeCard(scheme: provider.schemes[index]);
            },
          ),
        );
      },
    );
  }
}
