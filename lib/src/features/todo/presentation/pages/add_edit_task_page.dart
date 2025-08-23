import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/src/features/todo/presentation/widgets/task_list_item.dart'; // Import untuk format tanggal

// Definisikan enum untuk prioritas di luar class agar bisa diakses global
enum TaskPriority { none, low, medium, high }

class AddEditTaskPage extends StatefulWidget {
  final Todo? task;
  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskPage> {
  // Gunakan TextEditingController untuk mengelola input teks
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.none;

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dari task yang di-pass (jika ada)
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    // Asumsi class Todo punya properti 'description', 'dueDate', 'priority'
    // Jika belum ada, kamu perlu menambahkannya di class Todo
    _noteController = TextEditingController(
      text: '' /* widget.task?.description ?? '' */,
    );
    _dueDate = null; // widget.task?.dueDate;
    _priority =
        TaskPriority.none; // widget.task?.priority ?? TaskPriority.none;
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final canPop = Navigator.of(context).canPop();
    final isMobile = MediaQuery.of(context).size.width < 700;

    IconData getAdaptiveBackIcon() {
      if (!isMobile) {
        return Icons.close;
      }

      final platform = Theme.of(context).platform;
      if (platform == TargetPlatform.iOS) {
        return Icons.arrow_back_ios_new;
      }
      return Icons.arrow_back;
    }

    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                // Ganti ikon menjadi panah kembali agar lebih standar
                icon: Icon(getAdaptiveBackIcon()),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(
          isEditing ? 'Edit Tugas' : 'Tugas Baru',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (isEditing)
            IconButton(
              tooltip: 'Hapus Tugas',
              onPressed: () => _showDeleteConfirmation(context),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      // Gunakan SingleChildScrollView agar halaman bisa di-scroll saat keyboard muncul
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Urutan diubah agar lebih logis
              _buildTitleInput(),
              const SizedBox(height: 24),
              _buildDueDateSelector(context),
              const SizedBox(height: 24),
              _buildPrioritySelector(),
              const SizedBox(height: 24),
              _buildNotesInput(),
            ],
          ),
        ),
      ),
      // FIX: Bungkus dengan SafeArea agar ada padding bawah di mobile
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isMobile
              ? _buildMobileSaveButton(context)
              : _buildDesktopActionButtons(context),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER HELPER ---

  Widget _buildTitleInput() {
    // FIX: Dibungkus dengan Column untuk menambahkan label di atasnya
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Judul Tugas', // Label yang jelas
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText:
                'Contoh: Selesaikan laporan proyek', // Hint text yang lebih deskriptif
            hintStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
          ),
          autofocus: widget.task == null,
        ),
      ],
    );
  }

  Widget _buildDueDateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _dueDate = date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _dueDate != null
                    ? DateFormat('EEEE, d MMMM y', 'id_ID').format(_dueDate!)
                    : 'Pilih Tenggat Waktu',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            if (_dueDate != null)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _dueDate = null),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prioritas',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          children: [
            _buildPriorityChip(TaskPriority.high, 'Tinggi', Colors.red),
            _buildPriorityChip(TaskPriority.medium, 'Sedang', Colors.orange),
            _buildPriorityChip(TaskPriority.low, 'Rendah', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityChip(TaskPriority priority, String label, Color color) {
    final isSelected = _priority == priority;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _priority = selected ? priority : TaskPriority.none;
        });
      },
      avatar: Icon(
        Icons.flag_outlined,
        color: isSelected ? color : Colors.grey,
      ),
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
    );
  }

  Widget _buildNotesInput() {
    // FIX: Dibungkus dengan Column untuk menambahkan label di atasnya
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan', // Label yang jelas
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _noteController,
          decoration: InputDecoration(
            hintText:
                'Tambahkan detail atau sub-tugas...', // Hint text yang lebih deskriptif
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
          ),
          maxLines: 5,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text(
          'Yakin ingin menghapus tugas ini? Aksi ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete logic via BLoC
              Navigator.pop(dialogContext); // Tutup dialog
              context.pop(); // Kembali ke halaman sebelumnya
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Logika untuk menyimpan tugas (mengirim data ke BLoC)
        context.pop();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'Simpan Tugas',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDesktopActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => context.pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Batal',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Logika untuk menyimpan tugas (mengirim data ke BLoC)
            context.pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Simpan Tugas',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
