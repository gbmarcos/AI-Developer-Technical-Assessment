.PHONY: build gen clean buil_apk_relese
build: ## Generates files
	@echo "╠ Generating files..."
	@fvm dart run build_runner build --delete-conflicting-outputs
	@fvm flutter pub get

gen: ## Generates the assets
	@echo "╠ Generating the assets..."
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs

clean: ## Cleans the environment
	@echo "╠ Cleaning the project..."
	@rm -rf pubspec.lock
	@fvm flutter clean
	@fvm flutter pub get

build_apk_release:## Build release apk
	@echo "╠ Building release apk..."
	@fvm flutter build apk --release

set_flutter_3_19_0:
	@echo "╠ Setting to flutter 3.19.0..."
	@fvm use 3.19.0

update_ui_kit: ## Cleans the environment
	@echo "╠ Updating ui kit..."
	@fvm flutter pub upgrade juuz_ui_kit

watch: ## Generates the assets
	@echo "╠ Watching runner..."
	@fvm dart run build_runner watch --delete-conflicting-outputs


generate_app_icon: ## Generates the assets
	@echo "╠ Generating app Icon..."
	@fvm flutter pub run flutter_launcher_icons


assemble_debug: ## download debug android dependencies
	@echo "╠ Downloading debug android dependencies..."
	@cd android && ./gradlew clean
	@cd android && ./gradlew assembleDebug

activate_fvm: ## Activate fvm
	@echo "╠ Activating Flutter version manager..."
	@dart pub global activate fvm
