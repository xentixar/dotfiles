#!/bin/bash
# Quick Start Script for New C++ Projects
# Usage: ./new-project.sh <project-name>

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="$HOME/Projects/$PROJECT_NAME"

echo "Creating new C++ project: $PROJECT_NAME"
echo "Location: $PROJECT_DIR"

# Create project structure
mkdir -p "$PROJECT_DIR"/{src,include,tests,build,docs}

# Copy CMakeLists.txt template
cp ~/.emacs.d/templates/CMakeLists.txt.template "$PROJECT_DIR/CMakeLists.txt"
sed -i "s/MyProject/$PROJECT_NAME/g" "$PROJECT_DIR/CMakeLists.txt"

# Copy .clang-format template
cp ~/.emacs.d/templates/.clang-format.template "$PROJECT_DIR/.clang-format"

# Create main.cpp
cat > "$PROJECT_DIR/src/main.cpp" << 'EOF'
#include <iostream>

int main(int argc, char* argv[])
{
    std::cout << "Hello from C++!" << std::endl;
    return 0;
}
EOF

# Create header file
cat > "$PROJECT_DIR/include/${PROJECT_NAME}.h" << EOF
#ifndef ${PROJECT_NAME^^}_H
#define ${PROJECT_NAME^^}_H

// Your declarations here

#endif // ${PROJECT_NAME^^}_H
EOF

# Create README
cat > "$PROJECT_DIR/README.md" << EOF
# $PROJECT_NAME

Description of your project.

## Building

\`\`\`bash
cmake -B build
cmake --build build
\`\`\`

## Running

\`\`\`bash
./build/$PROJECT_NAME
\`\`\`
EOF

# Create .gitignore
cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# Build directories
build/
cmake-build-*/

# Compiled files
*.o
*.so
*.a
*.exe

# IDE files
.vscode/
.idea/
*.swp
*~

# Compile commands (regenerate on build)
# compile_commands.json

# Other
.DS_Store
EOF

# Initialize git
cd "$PROJECT_DIR"
git init
git add .
git commit -m "Initial commit"

# Generate compile_commands.json
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build
ln -sf build/compile_commands.json .

echo ""
echo "✅ Project created successfully!"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  emacs src/main.cpp"
echo ""
echo "Or open in Emacs:"
echo "  emacs --eval '(projectile-add-known-project \"$PROJECT_DIR\")'"
