c = get_config()
c.NbConvertApp.export_format = 'pdf'
c.TemplateExporter.template_path = ['.']
c.Exporter.template_file = 'article'

% Default to the notebook output style
((* set cell_style = 'style_notebook.tplx' *))
% Inherit from the specified cell style.
((* extends cell_style *))

((* block docclass *))
\documentclass{article}
((* endblock docclass *))

((* block maketitle *))((* endblock maketitle *))

((* block packages *))
((( super() ))) % load all other packages
\usepackage[T2A]{fontenc}
\usepackage[english, russian]{babel}
\usepackage{mathtools}
((* endblock packages *))