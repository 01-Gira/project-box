import 'dart:io';
import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/presentation/bloc/create_project/create_project_bloc.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _completionDateController = TextEditingController();

  File? _coverImageFile;
  String _selectedStatus = 'Planned';
  DateTime? _selectedCompletionDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _completionDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _coverImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToPickImage(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickCompletionDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedCompletionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedCompletionDate = pickedDate;
        _completionDateController.text = DateFormat(
          'd MMMM yyyy',
        ).format(pickedDate);
      });
    }
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      context.read<CreateProjectBloc>().add(
        ProjectSubmitted(
          name: _nameController.text,
          description: _descriptionController.text,
          coverImageFile: _coverImageFile,
          status: _selectedStatus,
          completionDate: _selectedCompletionDate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createProjectTitle), elevation: 1),
      body: BlocListener<CreateProjectBloc, CreateProjectState>(
        listener: (context, state) {
          if (state.state == RequestState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.somethingWentWrong),
                backgroundColor: colorScheme.error,
              ),
            );
          }
          if (state.state == RequestState.loaded) {
            Navigator.of(context).pop();
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildCoverImagePicker(context, l10n),
              const SizedBox(height: 24),
              _buildProjectNameField(l10n),
              const SizedBox(height: 16),

              _buildStatusDropdown(l10n),
              const SizedBox(height: 16),
              _buildCompletionDateField(l10n),
              const SizedBox(height: 16),

              // --- Akhir Widget Baru ---
              _buildDescriptionField(l10n),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CreateProjectBloc, CreateProjectState>(
          builder: (context, state) {
            if (state.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ElevatedButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.save),
              onPressed: _saveProject,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET-WIDGET PEMBANTU ---

  Widget _buildCoverImagePicker(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: _coverImageFile != null
                ? DecorationImage(
                    image: FileImage(_coverImageFile!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _coverImageFile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 40,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.choosePicture,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildProjectNameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.projectNameLabel,
        hintText: l10n.projectNameHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: Icon(Icons.folder_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.projectNameValidationError;
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(AppLocalizations l10n) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.projectDescriptionLabel,
        hintText: l10n.projectDescriptionHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: Icon(Icons.description_outlined),
      ),
      maxLines: 4,
    );
  }

  Widget _buildStatusDropdown(AppLocalizations l10n) {
    final statusOptions = ['Planned', 'Active', 'Done'];

    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: l10n.projectStatusLabel,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: const Icon(Icons.flag_outlined),
      ),
      items: statusOptions.map((String status) {
        return DropdownMenuItem<String>(value: status, child: Text(status));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue!;
        });
      },
    );
  }

  Widget _buildCompletionDateField(AppLocalizations l10n) {
    return TextFormField(
      controller: _completionDateController,
      decoration: InputDecoration(
        labelText: l10n.completionDateLabel,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: _completionDateController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _selectedCompletionDate = null;
                    _completionDateController.clear();
                  });
                },
              )
            : null,
      ),
      readOnly: true,
      onTap: _pickCompletionDate,
    );
  }
}
