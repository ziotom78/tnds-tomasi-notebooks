default:
    ls *.md | entr -r -s 'make && python3 -m http.server'
