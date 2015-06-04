<%
    default_title = "Scatterplot of '" + hda.name + "'"
    info = hda.name
    if hda.info:
        info += ' : ' + hda.info

    # optionally bootstrap data from dprov
    ##data = list( hda.datatype.dataset_column_dataprovider( hda, limit=10000 ) )

    # Use root for resource loading.
    root = h.url_for( '/' )
%>
## ----------------------------------------------------------------------------

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${title or default_title} | ${visualization_display_name}</title>

## ----------------------------------------------------------------------------

<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="http://code.jquery.com/ui/1.11.3/jquery-ui.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.21.5/js/jquery.tablesorter.min.js"></script>

</head>

## ----------------------------------------------------------------------------
<body>
    <div id="content">
      <h1>If you can see this, something is broken (or JS is not enabled)!!.</h1>
    </div>
    <script>
    /* jshint ignore:start */
      __REACT_DEVTOOLS_GLOBAL_HOOK__ = parent.__REACT_DEVTOOLS_GLOBAL_HOOK__;
    /* jshint ignore:end */
    </script>

    ${h.javascript_link( root + 'plugins/visualizations/jscoverageqc/static/assets/main.js' )}

</body>
