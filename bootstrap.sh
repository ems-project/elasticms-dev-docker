#/bin/bash
echo "Create/Update Filters"
../demo-preview.sh ems:admin:update filter dutch_stemmer
../demo-preview.sh ems:admin:update filter dutch_stop
../demo-preview.sh ems:admin:update filter empty_elision
../demo-preview.sh ems:admin:update filter english_stemmer
../demo-preview.sh ems:admin:update filter english_stop
../demo-preview.sh ems:admin:update filter french_elision
../demo-preview.sh ems:admin:update filter french_stemmer
../demo-preview.sh ems:admin:update filter french_stop
../demo-preview.sh ems:admin:update filter german_stemmer
../demo-preview.sh ems:admin:update filter german_stop


echo "Create/Update Analyzers"
../demo-preview.sh ems:admin:update analyzer alpha_order
../demo-preview.sh ems:admin:update analyzer dutch_for_highlighting
../demo-preview.sh ems:admin:update analyzer english_for_highlighting
../demo-preview.sh ems:admin:update analyzer french_for_highlighting
../demo-preview.sh ems:admin:update analyzer german_for_highlighting
../demo-preview.sh ems:admin:update analyzer html_strip