import 'package:flutter/material.dart';
import '../core/config/dev_settings.dart';
import '../core/config/app_config.dart';

/// Developer Settings Screen
/// Allows toggling AI mode and viewing/editing model paths
class DevSettingsScreen extends StatefulWidget {
  const DevSettingsScreen({Key? key}) : super(key: key);

  @override
  State<DevSettingsScreen> createState() => _DevSettingsScreenState();
}

class _DevSettingsScreenState extends State<DevSettingsScreen> {
  late DevSettings _settings;
  ModelPathValidation? _validation;
  bool _isLoading = true;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final settings = await DevSettings.load();
      final validation = await settings.validateModelPaths();
      
      setState(() {
        _settings = settings;
        _validation = validation;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load settings: $e');
    }
  }

  Future<void> _validatePaths() async {
    setState(() => _isValidating = true);
    
    try {
      final validation = await _settings.validateModelPaths();
      
      setState(() {
        _validation = validation;
        _isValidating = false;
      });

      if (validation.isValid) {
        _showSuccess('All model paths are valid! ✓');
      } else {
        _showError(validation.errorMessage);
      }
    } catch (e) {
      setState(() => _isValidating = false);
      _showError('Validation failed: $e');
    }
  }

  void _toggleAIMode() {
    setState(() {
      _settings.toggleAIMode();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI Mode: ${_settings.aiMode.displayName}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleDebugMode() {
    setState(() {
      _settings.setDebugMode(!_settings.enableDebugLogs);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Developer Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSettings,
            tooltip: 'Reload Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI Mode Section
          _buildSectionHeader('AI Mode'),
          _buildAIModeCard(),
          const SizedBox(height: 24),

          // Model Paths Section
          _buildSectionHeader('Local AI Model Paths'),
          _buildModelPathsCard(),
          const SizedBox(height: 24),

          // Validation Section
          _buildSectionHeader('Model Validation'),
          _buildValidationCard(),
          const SizedBox(height: 24),

          // Debug Settings Section
          _buildSectionHeader('Debug Settings'),
          _buildDebugSettingsCard(),
          const SizedBox(height: 24),

          // App Info Section
          _buildSectionHeader('App Information'),
          _buildAppInfoCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildAIModeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _settings.aiMode.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _settings.aiMode.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _settings.aiMode.isLLM,
                  onChanged: (_) => _toggleAIMode(),
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  _settings.aiMode.isNLU ? Icons.speed : Icons.chat,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  _settings.aiMode.isNLU 
                      ? 'Optimized for Games' 
                      : 'Optimized for Conversation',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelPathsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPathItem(
              'Whisper STT',
              _settings.whisperPath,
              _validation?.whisperExists ?? false,
              Icons.mic,
            ),
            const Divider(height: 24),
            _buildPathItem(
              'Qwen LLM',
              _settings.qwenPath,
              _validation?.qwenExists ?? false,
              Icons.psychology,
            ),
            const Divider(height: 24),
            _buildPathItem(
              'Coqui TTS',
              _settings.ttsPath,
              _validation?.ttsExists ?? false,
              Icons.volume_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathItem(String label, String path, bool exists, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.deepPurple),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              exists ? Icons.check_circle : Icons.error,
              color: exists ? Colors.green : Colors.red,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          path,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildValidationCard() {
    return Card(
      elevation: 4,
      color: _validation?.isValid == true ? Colors.green[50] : Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _validation?.isValid == true ? Icons.check_circle : Icons.error,
                  color: _validation?.isValid == true ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _validation?.toString() ?? 'Not validated yet',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isValidating ? null : _validatePaths,
                icon: _isValidating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(_isValidating ? 'Validating...' : 'Validate Paths'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugSettingsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Debug Logs'),
              subtitle: const Text('Show verbose logging in console'),
              value: _settings.enableDebugLogs,
              onChanged: (_) => _toggleDebugMode(),
              activeColor: Colors.deepPurple,
            ),
            SwitchListTile(
              title: const Text('Show Performance Overlay'),
              subtitle: const Text('Display FPS and performance metrics'),
              value: _settings.showPerformanceOverlay,
              onChanged: (_) => _toggleDebugMode(),
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('App Name', AppConfig.appName),
            _buildInfoRow('Arabic Name', AppConfig.appNameArabic),
            _buildInfoRow('Version', AppConfig.version),
            _buildInfoRow('Build Number', AppConfig.buildNumber),
            _buildInfoRow('Target Age', '${AppConfig.minAge}-${AppConfig.maxAge} years'),
            _buildInfoRow('Target FPS', '${AppConfig.targetFPS}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
