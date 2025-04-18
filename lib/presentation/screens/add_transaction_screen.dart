import 'dart:ffi';

import 'package:coba_lagi/data/models/category_model.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_bloc.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String? _description;
  String _type = 'income'; // Atau 'expense'
  String? _categoryId;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await Supabase.instance.client.from('categories').select();
    if (response != null) {
      setState(() {
        _categories = (response as List)
            .map((category) => CategoryModel.fromMap(category))
            .toList();
      });
    } else {
      // Tangani error jika ada
      print('Error fetching categories');
    }
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading state ke true
      });

      try {
        BlocProvider.of<TransactionBloc>(context).add(AddTransaction(
          amount: _amount,
          description: _description!,
          type: _type,
          categoryId: _categoryId!,
        ));

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Tangani error jika ada
        // print('Error adding transaction: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state ke false
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF2C8C7B),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The amount cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _amount = double.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type'),
                      DropdownButton<String>(
                        value: _type,
                        onChanged: (String? newValue) {
                          setState(() {
                            _type = newValue!;
                          });
                        },
                        items: <String>['income', 'expense']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category'),
                      DropdownButton<String>(
                        value: _categoryId != null && _categoryId!.isNotEmpty
                            ? _categoryId
                            : null, // Cek null sebelum akses isNotEmpty
                        hint: const Text('Choose a category'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _categoryId = newValue;
                          });
                        },
                        items: _categories.isNotEmpty
                            ? _categories.map<DropdownMenuItem<String>>(
                                (CategoryModel category) {
                                return DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList()
                            : [], // Kosongkan list jika kategori tidak ada
                      ),
                      if (_categories
                          .isEmpty) // Tampilkan teks jika kategori kosong
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'No categories available',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator() // Tampilkan indikator loading
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C8C7B),
                      ),
                      onPressed: _addTransaction,
                      child: Text('Add Transaction',
                          style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
