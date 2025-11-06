<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuralFlow - AI Assistant</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --bg-primary: #ffffff;
            --bg-secondary: #f8fafc;
            --bg-tertiary: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-tertiary: #94a3b8;
            --border: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --radius: 12px;
            --radius-sm: 8px;
        }

        [data-theme="dark"] {
            --bg-primary: #0f172a;
            --bg-secondary: #1e293b;
            --bg-tertiary: #334155;
            --text-primary: #f8fafc;
            --text-secondary: #cbd5e1;
            --text-tertiary: #64748b;
            --border: #334155;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            height: 100vh;
            overflow: hidden;
            transition: background-color 0.3s, color 0.3s;
        }

        .app-container {
            display: flex;
            height: 100vh;
            position: relative;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: var(--bg-secondary);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            z-index: 40;
        }

        .sidebar.collapsed {
            transform: translateX(-100%);
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid var(--border);
            background: var(--bg-primary);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 20px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .new-chat-btn {
            width: calc(100% - 40px);
            margin: 20px;
            padding: 12px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: var(--shadow-sm);
        }

        .new-chat-btn:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .chat-history {
            flex: 1;
            overflow-y: auto;
            padding: 0 20px 20px;
        }

        .chat-history::-webkit-scrollbar {
            width: 6px;
        }

        .chat-history::-webkit-scrollbar-track {
            background: transparent;
        }

        .chat-history::-webkit-scrollbar-thumb {
            background: var(--text-tertiary);
            border-radius: 3px;
        }

        .history-group {
            margin-bottom: 20px;
        }

        .history-group-title {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            padding: 0 4px;
        }

        .history-item {
            padding: 10px 12px;
            margin-bottom: 4px;
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
            position: relative;
        }

        .history-item:hover {
            background: var(--bg-tertiary);
        }

        .history-item.active {
            background: var(--bg-tertiary);
        }

        .history-item-icon {
            color: var(--text-tertiary);
            font-size: 14px;
        }

        .history-item-text {
            flex: 1;
            font-size: 14px;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .history-item-text.editing {
            background: var(--bg-primary);
            border: 1px solid var(--primary);
            padding: 4px 8px;
            border-radius: 4px;
            outline: none;
            color: var(--text-primary);
        }

        .history-item-actions {
            display: flex;
            gap: 4px;
            opacity: 0;
            transition: opacity 0.2s;
        }

        .history-item:hover .history-item-actions {
            opacity: 1;
        }

        .history-action-btn {
            width: 24px;
            height: 24px;
            border: none;
            background: transparent;
            color: var(--text-tertiary);
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .history-action-btn:hover {
            background: var(--bg-primary);
            color: var(--text-primary);
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid var(--border);
            background: var(--bg-primary);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: background 0.2s;
        }

        .user-menu:hover {
            background: var(--bg-secondary);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        .user-info {
            flex: 1;
        }

        .user-name {
            font-weight: 500;
            font-size: 14px;
        }

        .user-plan {
            font-size: 12px;
            color: var(--text-tertiary);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .header {
            height: 64px;
            border-bottom: 1px solid var(--border);
            background: var(--bg-primary);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .sidebar-toggle {
            width: 40px;
            height: 40px;
            border: none;
            background: var(--bg-secondary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            transition: all 0.2s;
        }

        .sidebar-toggle:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        .chat-title {
            font-size: 16px;
            font-weight: 500;
            color: var(--text-primary);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .model-selector {
            padding: 8px 16px;
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .model-selector:hover {
            border-color: var(--primary);
        }

        .header-btn {
            width: 40px;
            height: 40px;
            border: none;
            background: var(--bg-secondary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            transition: all 0.2s;
        }

        .header-btn:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        /* Chat Container */
        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: var(--bg-primary);
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: transparent;
        }

        .chat-messages::-webkit-scrollbar-thumb {
            background: var(--text-tertiary);
            border-radius: 4px;
        }

        .welcome-screen {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            text-align: center;
            padding: 40px;
        }

        .welcome-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            margin-bottom: 24px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        .welcome-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 12px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .welcome-subtitle {
            font-size: 16px;
            color: var(--text-secondary);
            margin-bottom: 40px;
            max-width: 500px;
        }

        .suggestion-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
            width: 100%;
            max-width: 800px;
        }

        .suggestion-card {
            padding: 20px;
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.2s;
            text-align: left;
        }

        .suggestion-card:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .suggestion-icon {
            width: 32px;
            height: 32px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            margin-bottom: 12px;
        }

        .suggestion-title {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
        }

        .suggestion-text {
            font-size: 14px;
            color: var(--text-secondary);
        }

        /* Message Styles */
        .message {
            display: flex;
            gap: 16px;
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            animation: fadeInUp 0.3s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 16px;
        }

        .message.user .message-avatar {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
        }

        .message.assistant .message-avatar {
            background: var(--bg-tertiary);
            color: var(--text-secondary);
        }

        .message-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .message-bubble {
            padding: 16px 20px;
            border-radius: var(--radius);
            position: relative;
            word-wrap: break-word;
            line-height: 1.6;
        }

        .message.user .message-bubble {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border-bottom-right-radius: 4px;
        }

        .message.assistant .message-bubble {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border-bottom-left-radius: 4px;
        }

        .message-attachments {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }

        .message-file {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-sm);
            font-size: 14px;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.2s;
        }

        .message-file:hover {
            background: var(--bg-primary);
            color: var(--text-primary);
        }

        .message-image {
            max-width: 300px;
            border-radius: var(--radius);
            margin-top: 8px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .message-image:hover {
            transform: scale(1.02);
        }

        .message-time {
            font-size: 12px;
            color: var(--text-tertiary);
            padding: 0 4px;
        }

        .message.user .message-time {
            text-align: right;
        }

        .message-actions {
            display: flex;
            gap: 8px;
            opacity: 0;
            transition: opacity 0.2s;
        }

        .message:hover .message-actions {
            opacity: 1;
        }

        .message-action {
            width: 32px;
            height: 32px;
            border: none;
            background: var(--bg-secondary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            transition: all 0.2s;
        }

        .message-action:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        /* Typing Indicator */
        .typing-indicator {
            display: none;
            align-items: center;
            gap: 4px;
            padding: 16px 20px;
            background: var(--bg-secondary);
            border-radius: var(--radius);
            border-bottom-left-radius: 4px;
            width: fit-content;
        }

        .typing-indicator.active {
            display: flex;
        }

        .typing-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--text-tertiary);
            animation: typing 1.4s infinite ease-in-out;
        }

        .typing-dot:nth-child(1) { animation-delay: -0.32s; }
        .typing-dot:nth-child(2) { animation-delay: -0.16s; }

        @keyframes typing {
            0%, 80%, 100% {
                transform: scale(0.8);
                opacity: 0.5;
            }
            40% {
                transform: scale(1);
                opacity: 1;
            }
        }

        /* Input Area */
        .input-area {
            padding: 24px;
            background: var(--bg-primary);
            border-top: 1px solid var(--border);
        }

        .input-wrapper {
            max-width: 800px;
            margin: 0 auto;
        }

        .input-container {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 12px;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            transition: all 0.2s;
        }

        .input-container:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .input-actions {
            display: flex;
            gap: 8px;
        }

        .input-btn {
            width: 36px;
            height: 36px;
            border: none;
            background: transparent;
            color: var(--text-tertiary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .input-btn:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        .chat-input {
            flex: 1;
            border: none;
            background: transparent;
            resize: none;
            font-size: 15px;
            line-height: 1.5;
            color: var(--text-primary);
            outline: none;
            font-family: inherit;
            max-height: 120px;
            overflow-y: auto;
        }

        .chat-input::placeholder {
            color: var(--text-tertiary);
        }

        .send-btn {
            width: 36px;
            height: 36px;
            border: none;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .send-btn:hover:not(:disabled) {
            transform: scale(1.05);
        }

        .send-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .file-input {
            display: none;
        }

        .uploaded-files {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 12px;
        }

        .file-tag {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            background: var(--bg-tertiary);
            border-radius: var(--radius-sm);
            font-size: 14px;
            color: var(--text-secondary);
        }

        .file-remove {
            background: none;
            border: none;
            color: var(--text-tertiary);
            cursor: pointer;
            padding: 2px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .file-remove:hover {
            color: var(--text-primary);
        }

        /* Image Preview */
        .image-preview {
            position: relative;
            display: inline-block;
            margin-top: 8px;
        }

        .image-preview img {
            max-width: 200px;
            max-height: 200px;
            border-radius: var(--radius-sm);
            object-fit: cover;
        }

        .image-preview-remove {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 24px;
            height: 24px;
            background: var(--danger-color, #ef4444);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        /* Settings Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.2s ease-out;
        }

        .modal.active {
            display: flex;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            background: var(--bg-primary);
            border-radius: var(--radius);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            animation: slideUp 0.3s ease-out;
        }

        @keyframes slideUp {
            from {
                transform: translateY(20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
        }

        .modal-close {
            width: 32px;
            height: 32px;
            border: none;
            background: var(--bg-secondary);
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            transition: all 0.2s;
        }

        .modal-close:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        .modal-body {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
        }

        .settings-section {
            margin-bottom: 32px;
        }

        .settings-section:last-child {
            margin-bottom: 0;
        }

        .settings-section-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-tertiary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 16px;
        }

        .setting-item {
            margin-bottom: 20px;
        }

        .setting-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-primary);
        }

        .setting-input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 14px;
            background: var(--bg-primary);
            color: var(--text-primary);
            transition: all 0.2s;
        }

        .setting-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .setting-textarea {
            min-height: 100px;
            resize: vertical;
            font-family: inherit;
        }

        .setting-select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 14px;
            background: var(--bg-primary);
            color: var(--text-primary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .setting-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .toggle-group {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .toggle-switch {
            position: relative;
            width: 48px;
            height: 24px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--bg-tertiary);
            transition: 0.3s;
            border-radius: 24px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background: white;
            transition: 0.3s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        }

        input:checked + .toggle-slider:before {
            transform: translateX(24px);
        }

        .modal-footer {
            padding: 24px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-secondary {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--bg-tertiary);
        }

        /* Toast Notification */
        .toast {
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            padding: 12px 24px;
            background: var(--text-primary);
            color: var(--bg-primary);
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            z-index: 2000;
            opacity: 0;
            transition: opacity 0.3s;
            pointer-events: none;
        }

        .toast.show {
            opacity: 1;
            pointer-events: auto;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                z-index: 50;
                box-shadow: var(--shadow-lg);
            }

            .sidebar.collapsed {
                transform: translateX(-100%);
            }

            .sidebar-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 45;
            }

            .sidebar-overlay.active {
                display: block;
            }

            .chat-title {
                display: none;
            }

            .header-right {
                gap: 8px;
            }

            .model-selector {
                display: none;
            }

            .welcome-screen {
                padding: 20px;
            }

            .welcome-title {
                font-size: 24px;
            }

            .suggestion-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Sidebar Overlay for Mobile -->
        <div class="sidebar-overlay" id="sidebarOverlay"></div>
        
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-brain"></i>
                    </div>
                    <span>NeuralFlow</span>
                </div>
            </div>
            
            <button class="new-chat-btn" id="newChatBtn">
                <i class="fas fa-plus"></i>
                <span>New Conversation</span>
            </button>
            
            <div class="chat-history" id="chatHistory">
                <div class="history-group">
                    <div class="history-group-title">Today</div>
                    <div id="todayChats"></div>
                </div>
                <div class="history-group">
                    <div class="history-group-title">Yesterday</div>
                    <div id="yesterdayChats"></div>
                </div>
                <div class="history-group">
                    <div class="history-group-title">Previous 7 Days</div>
                    <div id="weekChats"></div>
                </div>
            </div>
            
            <div class="sidebar-footer">
                <div class="user-menu">
                    <div class="user-avatar">U</div>
                    <div class="user-info">
                        <div class="user-name">User</div>
                        <div class="user-plan">Free Plan</div>
                    </div>
                    <i class="fas fa-chevron-up" style="color: var(--text-tertiary); font-size: 12px;"></i>
                </div>
            </div>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
                <div class="header-left">
                    <button class="sidebar-toggle" id="sidebarToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="chat-title" id="chatTitle">New Conversation</div>
                </div>
                <div class="header-right">
                    <select class="model-selector" id="modelSelector">
                        <option value="gpt-4">GPT-4</option>
                        <option value="gpt-4-turbo">GPT-4 Turbo</option>
                        <option value="claude-3-opus">Claude 3 Opus</option>
                        <option value="claude-3-sonnet">Claude 3 Sonnet</option>
                        <option value="claude-3-haiku">Claude 3 Haiku</option>
                        <option value="gemini-pro">Gemini Pro</option>
                    </select>
                    <button class="header-btn" id="voiceBtn">
                        <i class="fas fa-microphone"></i>
                    </button>
                    <button class="header-btn" id="settingsBtn">
                        <i class="fas fa-cog"></i>
                    </button>
                </div>
            </header>
            
            <div class="chat-container">
                <div class="chat-messages" id="chatMessages">
                    <div class="welcome-screen" id="welcomeScreen">
                        <div class="welcome-icon">
                            <i class="fas fa-brain"></i>
                        </div>
                        <h1 class="welcome-title">Welcome to NeuralFlow</h1>
                        <p class="welcome-subtitle">Your intelligent conversation partner. Ask me anything!</p>
                        
                        <div class="suggestion-grid">
                            <div class="suggestion-card" data-prompt="Help me write a professional email">
                                <div class="suggestion-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="suggestion-title">Write Professional Email</div>
                                <div class="suggestion-text">Get help crafting the perfect professional email</div>
                            </div>
                            <div class="suggestion-card" data-prompt="Explain machine learning basics">
                                <div class="suggestion-icon">
                                    <i class="fas fa-brain"></i>
                                </div>
                                <div class="suggestion-title">Learn Something New</div>
                                <div class="suggestion-text">Understand complex topics in simple terms</div>
                            </div>
                            <div class="suggestion-card" data-prompt="Create a workout plan for beginners">
                                <div class="suggestion-icon">
                                    <i class="fas fa-dumbbell"></i>
                                </div>
                                <div class="suggestion-title">Health & Fitness</div>
                                <div class="suggestion-text">Get personalized workout and nutrition advice</div>
                            </div>
                            <div class="suggestion-card" data-prompt="Brainstorm business ideas">
                                <div class="suggestion-icon">
                                    <i class="fas fa-lightbulb"></i>
                                </div>
                                <div class="suggestion-title">Creative Ideas</div>
                                <div class="suggestion-text">Generate innovative concepts and solutions</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="input-area">
                    <div class="input-wrapper">
                        <div class="input-container">
                            <div class="input-actions">
                                <button class="input-btn" id="attachBtn">
                                    <i class="fas fa-paperclip"></i>
                                </button>
                                <input type="file" id="fileInput" class="file-input" multiple>
                            </div>
                            <textarea class="chat-input" id="chatInput" placeholder="Type your message here... (Ctrl+V to paste images)" rows="1"></textarea>
                            <button class="send-btn" id="sendBtn">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                        <div class="uploaded-files" id="uploadedFiles"></div>
                        <div class="uploaded-files" id="imagePreviews"></div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Settings Modal -->
    <div class="modal" id="settingsModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Settings</h2>
                <button class="modal-close" id="closeSettingsBtn">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="settings-section">
                    <h3 class="settings-section-title">General</h3>
                    <div class="setting-item">
                        <label class="setting-label">Default Model</label>
                        <select class="setting-select" id="defaultModelSelect">
                            <option value="gpt-4">GPT-4</option>
                            <option value="gpt-4-turbo">GPT-4 Turbo</option>
                            <option value="claude-3-opus">Claude 3 Opus</option>
                            <option value="claude-3-sonnet">Claude 3 Sonnet</option>
                            <option value="claude-3-haiku">Claude 3 Haiku</option>
                            <option value="gemini-pro">Gemini Pro</option>
                        </select>
                    </div>
                    <div class="setting-item">
                        <label class="setting-label">Theme</label>
                        <select class="setting-select" id="themeSelect">
                            <option value="light">Light</option>
                            <option value="dark">Dark</option>
                            <option value="auto">Auto</option>
                        </select>
                    </div>
                </div>
                
                <div class="settings-section">
                    <h3 class="settings-section-title">Conversation</h3>
                    <div class="setting-item">
                        <label class="setting-label">System Prompt</label>
                        <textarea class="setting-input setting-textarea" id="systemPromptInput" placeholder="Enter a system prompt to guide the AI's behavior..."></textarea>
                    </div>
                    <div class="setting-item">
                        <div class="toggle-group">
                            <label class="setting-label" style="margin: 0;">Save Chat History</label>
                            <label class="toggle-switch">
                                <input type="checkbox" id="saveHistoryToggle" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <h3 class="settings-section-title">Voice</h3>
                    <div class="setting-item">
                        <div class="toggle-group">
                            <label class="setting-label" style="margin: 0;">Voice Input</label>
                            <label class="toggle-switch">
                                <input type="checkbox" id="voiceInputToggle">
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="toggle-group">
                            <label class="setting-label" style="margin: 0;">Text-to-Speech</label>
                            <label class="toggle-switch">
                                <input type="checkbox" id="ttsToggle">
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" id="cancelSettingsBtn">Cancel</button>
                <button class="btn btn-primary" id="saveSettingsBtn">Save Changes</button>
            </div>
        </div>
    </div>
    
    <!-- Toast Notification -->
    <div class="toast" id="toast"></div>
    
    <script>
        // App State
        const app = {
            currentChatId: null,
            chats: JSON.parse(localStorage.getItem('chats')) || {},
            settings: JSON.parse(localStorage.getItem('settings')) || {
                defaultModel: 'gpt-4',
                theme: 'light',
                systemPrompt: '',
                saveHistory: true,
                voiceInput: false,
                tts: false
            },
            uploadedFiles: [],
            pastedImages: [],
            isGenerating: false,
            sidebarOpen: true
        };
        
        // DOM Elements
        const elements = {
            sidebar: document.getElementById('sidebar'),
            sidebarOverlay: document.getElementById('sidebarOverlay'),
            sidebarToggle: document.getElementById('sidebarToggle'),
            newChatBtn: document.getElementById('newChatBtn'),
            todayChats: document.getElementById('todayChats'),
            yesterdayChats: document.getElementById('yesterdayChats'),
            weekChats: document.getElementById('weekChats'),
            chatTitle: document.getElementById('chatTitle'),
            modelSelector: document.getElementById('modelSelector'),
            voiceBtn: document.getElementById('voiceBtn'),
            settingsBtn: document.getElementById('settingsBtn'),
            settingsModal: document.getElementById('settingsModal'),
            closeSettingsBtn: document.getElementById('closeSettingsBtn'),
            cancelSettingsBtn: document.getElementById('cancelSettingsBtn'),
            saveSettingsBtn: document.getElementById('saveSettingsBtn'),
            chatMessages: document.getElementById('chatMessages'),
            welcomeScreen: document.getElementById('welcomeScreen'),
            chatInput: document.getElementById('chatInput'),
            sendBtn: document.getElementById('sendBtn'),
            attachBtn: document.getElementById('attachBtn'),
            fileInput: document.getElementById('fileInput'),
            uploadedFiles: document.getElementById('uploadedFiles'),
            imagePreviews: document.getElementById('imagePreviews'),
            toast: document.getElementById('toast'),
            // Settings elements
            defaultModelSelect: document.getElementById('defaultModelSelect'),
            themeSelect: document.getElementById('themeSelect'),
            systemPromptInput: document.getElementById('systemPromptInput'),
            saveHistoryToggle: document.getElementById('saveHistoryToggle'),
            voiceInputToggle: document.getElementById('voiceInputToggle'),
            ttsToggle: document.getElementById('ttsToggle')
        };
        
        // Initialize App
        function init() {
            loadSettings();
            applyTheme();
            loadChatHistory();
            
            if (!app.currentChatId) {
                createNewChat();
            }
            
            setupEventListeners();
            setupAutoResize();
            setupPasteHandler();
            
            // Check screen size
            if (window.innerWidth <= 768) {
                app.sidebarOpen = false;
                elements.sidebar.classList.add('collapsed');
            }
        }
        
        // Theme Management
        function applyTheme() {
            const theme = app.settings.theme;
            
            if (theme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
            } else if (theme === 'light') {
                document.documentElement.removeAttribute('data-theme');
            } else if (theme === 'auto') {
                const hour = new Date().getHours();
                if (hour >= 18 || hour < 6) {
                    document.documentElement.setAttribute('data-theme', 'dark');
                } else {
                    document.documentElement.removeAttribute('data-theme');
                }
            }
        }
        
        function checkAutoTheme() {
            if (app.settings.theme === 'auto') {
                applyTheme();
            }
        }
        
        // Settings Management
        function loadSettings() {
            elements.defaultModelSelect.value = app.settings.defaultModel;
            elements.themeSelect.value = app.settings.theme;
            elements.systemPromptInput.value = app.settings.systemPrompt;
            elements.saveHistoryToggle.checked = app.settings.saveHistory;
            elements.voiceInputToggle.checked = app.settings.voiceInput;
            elements.ttsToggle.checked = app.settings.tts;
            
            elements.modelSelector.value = app.settings.defaultModel;
        }
        
        function saveSettings() {
            app.settings.defaultModel = elements.defaultModelSelect.value;
            app.settings.theme = elements.themeSelect.value;
            app.settings.systemPrompt = elements.systemPromptInput.value;
            app.settings.saveHistory = elements.saveHistoryToggle.checked;
            app.settings.voiceInput = elements.voiceInputToggle.checked;
            app.settings.tts = elements.ttsToggle.checked;
            
            localStorage.setItem('settings', JSON.stringify(app.settings));
            
            applyTheme();
            elements.modelSelector.value = app.settings.defaultModel;
            showToast('Settings saved successfully');
        }
        
        // Chat Management
        function createNewChat() {
            const chatId = generateId();
            app.currentChatId = chatId;
            app.chats[chatId] = {
                id: chatId,
                title: 'New Conversation',
                messages: [],
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString()
            };
            
            elements.chatInput.value = '';
            elements.chatMessages.innerHTML = '';
            elements.welcomeScreen.style.display = 'flex';
            elements.chatTitle.textContent = 'New Conversation';
            
            // Clear uploads
            app.uploadedFiles = [];
            app.pastedImages = [];
            elements.uploadedFiles.innerHTML = '';
            elements.imagePreviews.innerHTML = '';
            
            loadChatHistory();
            
            if (app.settings.saveHistory) {
                saveChats();
            }
        }
        
        function loadChat(chatId) {
            if (!app.chats[chatId]) return;
            
            app.currentChatId = chatId;
            const chat = app.chats[chatId];
            
            elements.chatTitle.textContent = chat.title;
            elements.chatMessages.innerHTML = '';
            elements.welcomeScreen.style.display = 'none';
            
            chat.messages.forEach(message => {
                addMessageToChat(message);
            });
            
            loadChatHistory();
            
            if (window.innerWidth <= 768) {
                toggleSidebar();
            }
        }
        
        function deleteChat(chatId) {
            if (!app.chats[chatId]) return;
            
            if (confirm('Delete this conversation?')) {
                delete app.chats[chatId];
                
                if (chatId === app.currentChatId) {
                    createNewChat();
                }
                
                loadChatHistory();
                
                if (app.settings.saveHistory) {
                    saveChats();
                }
            }
        }
        
        function saveChats() {
            localStorage.setItem('chats', JSON.stringify(app.chats));
        }
        
        function loadChatHistory() {
            // Clear existing chat history
            elements.todayChats.innerHTML = '';
            elements.yesterdayChats.innerHTML = '';
            elements.weekChats.innerHTML = '';
            
            const now = new Date();
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const yesterday = new Date(today);
            yesterday.setDate(yesterday.getDate() - 1);
            const weekAgo = new Date(today);
            weekAgo.setDate(weekAgo.getDate() - 7);
            
            const sortedChats = Object.entries(app.chats).sort((a, b) => 
                new Date(b[1].updatedAt) - new Date(a[1].updatedAt)
            );
            
            sortedChats.forEach(([chatId, chat]) => {
                const chatDate = new Date(chat.updatedAt);
                const chatItem = createChatItem(chatId, chat);
                
                if (chatDate >= today) {
                    elements.todayChats.appendChild(chatItem);
                } else if (chatDate >= yesterday) {
                    elements.yesterdayChats.appendChild(chatItem);
                } else if (chatDate >= weekAgo) {
                    elements.weekChats.appendChild(chatItem);
                }
            });
        }
        
        function createChatItem(chatId, chat) {
            const item = document.createElement('div');
            item.className = 'history-item';
            if (chatId === app.currentChatId) {
                item.classList.add('active');
            }
            
            item.innerHTML = `
                <i class="fas fa-message history-item-icon"></i>
                <span class="history-item-text" data-chat-id="${chatId}">${chat.title}</span>
                <div class="history-item-actions">
                    <button class="history-action-btn" data-action="edit" data-chat-id="${chatId}">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="history-action-btn" data-action="delete" data-chat-id="${chatId}">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
            
            // Add event listeners
            item.addEventListener('click', (e) => {
                if (!e.target.closest('.history-item-actions')) {
                    loadChat(chatId);
                }
            });
            
            const editBtn = item.querySelector('[data-action="edit"]');
            const deleteBtn = item.querySelector('[data-action="delete"]');
            
            editBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                startEditingChatTitle(chatId);
            });
            
            deleteBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                deleteChat(chatId);
            });
            
            return item;
        }
        
        function startEditingChatTitle(chatId) {
            const chat = app.chats[chatId];
            if (!chat) return;
            
            const titleElement = document.querySelector(`.history-item-text[data-chat-id="${chatId}"]`);
            if (!titleElement) return;
            
            const currentTitle = chat.title;
            titleElement.contentEditable = true;
            titleElement.classList.add('editing');
            titleElement.focus();
            
            // Select all text
            const range = document.createRange();
            range.selectNodeContents(titleElement);
            const selection = window.getSelection();
            selection.removeAllRanges();
            selection.addRange(range);
            
            const finishEditing = () => {
                const newTitle = titleElement.textContent.trim();
                if (newTitle && newTitle !== currentTitle) {
                    chat.title = newTitle;
                    chat.updatedAt = new Date().toISOString();
                    
                    if (chatId === app.currentChatId) {
                        elements.chatTitle.textContent = newTitle;
                    }
                    
                    if (app.settings.saveHistory) {
                        saveChats();
                    }
                    
                    showToast('Chat title updated');
                } else {
                    titleElement.textContent = currentTitle;
                }
                
                titleElement.contentEditable = false;
                titleElement.classList.remove('editing');
            };
            
            titleElement.addEventListener('blur', finishEditing, { once: true });
            titleElement.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    titleElement.blur();
                } else if (e.key === 'Escape') {
                    titleElement.textContent = currentTitle;
                    titleElement.blur();
                }
            });
        }
        
        // Message Management
        function addMessageToChat(messageData) {
            elements.welcomeScreen.style.display = 'none';
            
            const message = document.createElement('div');
            message.className = `message ${messageData.role}`;
            
            const time = new Date(messageData.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            
            let attachmentsHtml = '';
            if (messageData.attachments && messageData.attachments.length > 0) {
                attachmentsHtml = '<div class="message-attachments">';
                messageData.attachments.forEach(attachment => {
                    if (attachment.type === 'image') {
                        attachmentsHtml += `<img src="${attachment.url}" alt="${attachment.name}" class="message-image" onclick="window.open('${attachment.url}', '_blank')">`;
                    } else {
                        attachmentsHtml += `
                            <a href="${attachment.url}" class="message-file" download="${attachment.name}">
                                <i class="fas fa-file"></i>
                                <span>${attachment.name}</span>
                            </a>
                        `;
                    }
                });
                attachmentsHtml += '</div>';
            }
            
            message.innerHTML = `
                <div class="message-avatar">
                    <i class="fas fa-${messageData.role === 'user' ? 'user' : 'robot'}"></i>
                </div>
                <div class="message-content">
                    <div class="message-bubble">${messageData.content}</div>
                    ${attachmentsHtml}
                    <div class="message-time">${time}</div>
                    <div class="message-actions">
                        <button class="message-action" onclick="copyMessage(this)">
                            <i class="fas fa-copy"></i>
                        </button>
                        <button class="message-action" onclick="regenerateResponse(this)">
                            <i class="fas fa-redo"></i>
                        </button>
                    </div>
                </div>
            `;
            
            elements.chatMessages.appendChild(message);
            elements.chatMessages.scrollTop = elements.chatMessages.scrollHeight;
            
            if (messageData.role === 'assistant') {
                showTypingIndicator(message);
            }
        }
        
        function addMessage(role, content, attachments = []) {
            const messageData = {
                role,
                content,
                attachments,
                timestamp: new Date().toISOString()
            };
            
            addMessageToChat(messageData);
            
            // Save to chat history
            const chat = app.chats[app.currentChatId];
            chat.messages.push(messageData);
            chat.updatedAt = new Date().toISOString();
            
            if (app.settings.saveHistory) {
                saveChats();
            }
        }
        
        function showTypingIndicator(messageElement) {
            const bubble = messageElement.querySelector('.message-bubble');
            const typingIndicator = document.createElement('div');
            typingIndicator.className = 'typing-indicator active';
            typingIndicator.innerHTML = `
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
            `;
            
            bubble.appendChild(typingIndicator);
            
            setTimeout(() => {
                typingIndicator.remove();
            }, 1500);
        }
        
        async function sendMessage() {
            const message = elements.chatInput.value.trim();
            const hasAttachments = app.uploadedFiles.length > 0 || app.pastedImages.length > 0;
            
            if ((!message && !hasAttachments) || app.isGenerating) return;
            
            // Prepare attachments
            const attachments = [];
            
            // Add uploaded files
            app.uploadedFiles.forEach(file => {
                attachments.push({
                    name: file.name,
                    type: file.type.startsWith('image/') ? 'image' : 'file',
                    url: URL.createObjectURL(file)
                });
            });
            
            // Add pasted images
            app.pastedImages.forEach(image => {
                attachments.push({
                    name: image.name,
                    type: 'image',
                    url: image.url
                });
            });
            
            // Add user message
            addMessage('user', message, attachments);
            
            // Clear input and uploads
            elements.chatInput.value = '';
            elements.uploadedFiles.innerHTML = '';
            elements.imagePreviews.innerHTML = '';
            app.uploadedFiles = [];
            app.pastedImages = [];
            setupAutoResize();
            
            app.isGenerating = true;
            elements.sendBtn.disabled = true;
            
            const chat = app.chats[app.currentChatId];
            
            if (chat.messages.length === 1 && message) {
                chat.title = message.substring(0, 30) + (message.length > 30 ? '...' : 'New Conversation');
                elements.chatTitle.textContent = chat.title;
            }
            
            loadChatHistory();
            
            // Simulate AI response
            setTimeout(() => {
                let response = generateAIResponse(message);
                
                // Add context about attachments
                if (attachments.length > 0) {
                    const imageCount = attachments.filter(a => a.type === 'image').length;
                    const fileCount = attachments.filter(a => a.type === 'file').length;
                    
                    if (imageCount > 0 && fileCount > 0) {
                        response = `I can see you've shared ${imageCount} image${imageCount > 1 ? 's' : ''} and ${fileCount} file${fileCount > 1 ? 's' : ''}. ${response}`;
                    } else if (imageCount > 0) {
                        response = `I can see the image${imageCount > 1 ? 's' : ''} you've shared. ${response}`;
                    } else if (fileCount > 0) {
                        response = `I've received the file${fileCount > 1 ? 's' : ''} you've uploaded. ${response}`;
                    }
                }
                
                addMessage('assistant', response);
                
                app.isGenerating = false;
                elements.sendBtn.disabled = false;
            }, 1500);
        }
        
        function generateAIResponse(message) {
            const responses = [
                "I understand your question. Let me provide you with a comprehensive answer.",
                "That's an interesting point! Here's what I think about it.",
                "I'd be happy to help you with that. Let me explain in detail.",
                "Great question! Based on my knowledge, I can tell you that...",
                "I see what you're asking. Let me break this down for you."
            ];
            
            const baseResponse = responses[Math.floor(Math.random() * responses.length)];
            
            if (message.toLowerCase().includes('hello') || message.toLowerCase().includes('hi')) {
                return "Hello! How can I assist you today?";
            } else if (message.toLowerCase().includes('how are you')) {
                return "I'm functioning perfectly and ready to help! What can I do for you?";
            } else if (message.toLowerCase().includes('thank')) {
                return "You're very welcome! Is there anything else I can help you with?";
            } else if (message.toLowerCase().includes('bye')) {
                return "Goodbye! Feel free to return anytime you need assistance.";
            } else {
                return `${baseResponse} This is a simulated response as this is a frontend demo. In a real implementation, this would connect to an actual AI API to provide intelligent responses.`;
            }
        }
        
        // File Upload
        function handleFileUpload() {
            const files = Array.from(elements.fileInput.files);
            
            files.forEach(file => {
                app.uploadedFiles.push(file);
                
                const fileTag = document.createElement('div');
                fileTag.className = 'file-tag';
                fileTag.innerHTML = `
                    <i class="fas fa-file"></i>
                    <span>${file.name}</span>
                    <button class="file-remove" onclick="removeFile(this, '${file.name}')">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                
                elements.uploadedFiles.appendChild(fileTag);
            });
            
            elements.fileInput.value = '';
        }
        
        function removeFile(button, fileName) {
            app.uploadedFiles = app.uploadedFiles.filter(f => f.name !== fileName);
            button.parentElement.remove();
        }
        
        // Image Paste Handler
        function setupPasteHandler() {
            elements.chatInput.addEventListener('paste', (e) => {
                const items = e.clipboardData.items;
                let hasImage = false;
                
                for (let item of items) {
                    if (item.type.indexOf('image') !== -1) {
                        hasImage = true;
                        const file = item.getAsFile();
                        const reader = new FileReader();
                        
                        reader.onload = (event) => {
                            const imageData = {
                                name: `Pasted Image ${Date.now()}.png`,
                                url: event.target.result
                            };
                            
                            app.pastedImages.push(imageData);
                            
                            const preview = document.createElement('div');
                            preview.className = 'image-preview';
                            preview.innerHTML = `
                                <img src="${imageData.url}" alt="${imageData.name}">
                                <button class="image-preview-remove" onclick="removePastedImage(this, '${imageData.name}')">
                                    <i class="fas fa-times"></i>
                                </button>
                            `;
                            
                            elements.imagePreviews.appendChild(preview);
                        };
                        
                        reader.readAsDataURL(file);
                    }
                }
                
                if (hasImage) {
                    e.preventDefault();
                    showToast('Image pasted successfully!');
                }
            });
        }
        
        function removePastedImage(button, imageName) {
            app.pastedImages = app.pastedImages.filter(img => img.name !== imageName);
            button.parentElement.remove();
        }
        
        // UI Helpers
        function toggleSidebar() {
            app.sidebarOpen = !app.sidebarOpen;
            
            if (app.sidebarOpen) {
                elements.sidebar.classList.remove('collapsed');
                if (window.innerWidth <= 768) {
                    elements.sidebarOverlay.classList.add('active');
                }
            } else {
                elements.sidebar.classList.add('collapsed');
                elements.sidebarOverlay.classList.remove('active');
            }
        }
        
        function setupAutoResize() {
            elements.chatInput.style.height = 'auto';
            elements.chatInput.style.height = Math.min(elements.chatInput.scrollHeight, 120) + 'px';
        }
        
        function generateId() {
            return Date.now().toString(36) + Math.random().toString(36).substr(2);
        }
        
        function showToast(message) {
            elements.toast.textContent = message;
            elements.toast.classList.add('show');
            
            setTimeout(() => {
                elements.toast.classList.remove('show');
            }, 3000);
        }
        
        // Global functions for inline event handlers
        window.copyMessage = function(button) {
            const message = button.closest('.message').querySelector('.message-bubble').textContent;
            navigator.clipboard.writeText(message);
            showToast('Message copied to clipboard');
        };
        
        window.regenerateResponse = function(button) {
            const message = button.closest('.message');
            // In a real app, this would regenerate the response
            showToast('Regenerating response...');
        };
        
        window.removeFile = removeFile;
        window.removePastedImage = removePastedImage;
        
        // Event Listeners
        function setupEventListeners() {
            // Sidebar
            elements.sidebarToggle.addEventListener('click', toggleSidebar);
            elements.sidebarOverlay.addEventListener('click', toggleSidebar);
            elements.newChatBtn.addEventListener('click', createNewChat);
            
            // Settings
            elements.settingsBtn.addEventListener('click', () => {
                elements.settingsModal.classList.add('active');
            });
            
            elements.closeSettingsBtn.addEventListener('click', () => {
                elements.settingsModal.classList.remove('active');
            });
            
            elements.cancelSettingsBtn.addEventListener('click', () => {
                elements.settingsModal.classList.remove('active');
                loadSettings();
            });
            
            elements.saveSettingsBtn.addEventListener('click', () => {
                saveSettings();
                elements.settingsModal.classList.remove('active');
            });
            
            // Chat
            elements.chatInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            elements.chatInput.addEventListener('input', setupAutoResize);
            
            elements.sendBtn.addEventListener('click', sendMessage);
            
            // File Upload
            elements.attachBtn.addEventListener('click', () => {
                elements.fileInput.click();
            });
            
            elements.fileInput.addEventListener('change', handleFileUpload);
            
            // Voice
            elements.voiceBtn.addEventListener('click', () => {
                if (app.settings.voiceInput) {
                    showToast('Voice input activated');
                } else {
                    showToast('Enable voice input in settings');
                }
            });
            
            // Suggestions
            document.querySelectorAll('.suggestion-card').forEach(card => {
                card.addEventListener('click', () => {
                    const prompt = card.dataset.prompt;
                    elements.chatInput.value = prompt;
                    setupAutoResize();
                    elements.chatInput.focus();
                });
            });
            
            // Window resize
            window.addEventListener('resize', () => {
                if (window.innerWidth > 768) {
                    app.sidebarOpen = true;
                    elements.sidebar.classList.remove('collapsed');
                    elements.sidebarOverlay.classList.remove('active');
                }
            });
            
            // Auto theme check for "auto" mode
            setInterval(checkAutoTheme, 60000); // Check every minute
        }
        
        // Initialize app
        document.addEventListener('DOMContentLoaded', init);
    </script>
</body>
</html>
