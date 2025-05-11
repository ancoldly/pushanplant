import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_flutter_app/models/LabelTreeModel.dart';
import 'package:my_flutter_app/provider/label_tree_provider.dart';

import '../views_admin/admin_detailLabelTree_screen.dart';
import '../widget/label_tree_card_custom.dart';

class SearchLabelTreeScreen extends StatefulWidget {
  const SearchLabelTreeScreen({super.key});

  @override
  State<SearchLabelTreeScreen> createState() => _SearchLabelTreeScreenState();
}

class _SearchLabelTreeScreenState extends State<SearchLabelTreeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LabelTreeModel> _filteredLabelTrees = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LabelTreeProvider>(context, listen: false);
    provider.fetchLabelTrees().then((_) {
      setState(() {
        _filteredLabelTrees = provider.labelTrees;
      });
    });
  }

  void _onSearchChanged(String query) {
    final provider = Provider.of<LabelTreeProvider>(context, listen: false);
    setState(() {
      _filteredLabelTrees = provider.labelTrees.where((label) {
        return label.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LabelTreeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Tìm kiếm nhãn cây trồng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white, thickness: 1),
              const SizedBox(height: 20),

              const Text(
                "Hãy nhập tên loại nhãn bạn muốn tìm vào đây.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nhập tên nhãn cần tìm...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: provider.labelTrees.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredLabelTrees.isEmpty
                    ? const Center(
                  child: Text(
                    'Không tìm thấy nhãn phù hợp.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredLabelTrees.length,
                  itemBuilder: (context, index) {
                    final label = _filteredLabelTrees[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: LabelTreeCardCustom(
                        labelTree: label,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const AdminDetailLabelTreeScreen(),
                              settings: RouteSettings(
                                  arguments: label.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
