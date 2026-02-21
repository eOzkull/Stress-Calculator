import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/stress_calculator_service.dart';
import '../models/stress_result.dart';
import 'result_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _ageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate processing delay for better UX
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        final result = StressCalculatorService.calculateStress(
          systolicBP: int.parse(_systolicController.text),
          diastolicBP: int.parse(_diastolicController.text),
          pulseRate: int.parse(_pulseController.text),
          age: _ageController.text.isEmpty 
              ? null 
              : int.parse(_ageController.text),
        );

        setState(() => _isLoading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result),
          ),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Measurement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Enter Your Vitals',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll analyze your blood pressure and pulse rate to calculate your current stress level.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // Blood Pressure Section
                _buildSectionTitle(context, 'Blood Pressure', Icons.favorite),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _systolicController,
                        label: 'Systolic',
                        hint: '120',
                        suffix: 'mmHg',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final num = int.tryParse(value);
                          if (num == null || num < 70 || num > 250) {
                            return '70-250';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('/', style: theme.textTheme.headlineMedium),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        controller: _diastolicController,
                        label: 'Diastolic',
                        hint: '80',
                        suffix: 'mmHg',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final num = int.tryParse(value);
                          if (num == null || num < 40 || num > 150) {
                            return '40-150';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pulse Rate
                _buildSectionTitle(context, 'Pulse Rate', Icons.monitor_heart),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _pulseController,
                  label: 'Heart Rate',
                  hint: '72',
                  suffix: 'BPM',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pulse rate';
                    }
                    final num = int.tryParse(value);
                    if (num == null || num < 40 || num > 200) {
                      return 'Please enter a value between 40-200';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Age (Optional)
                _buildSectionTitle(context, 'Age (Optional)', Icons.cake),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _ageController,
                  label: 'Your Age',
                  hint: '30',
                  suffix: 'years',
                  isOptional: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = int.tryParse(value);
                      if (num == null || num < 1 || num > 120) {
                        return 'Invalid age';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _calculate,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Calculate Stress Level',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tip: Measure after resting for 5 minutes in a seated position for most accurate results.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required String? Function(String?) validator,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        labelText: label + (isOptional ? ' (Optional)' : ''),
        hintText: hint,
        suffixText: suffix,
      ),
      validator: validator,
    );
  }
}