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
<%
    history_id = trans.security.encode_id( trans.history.id )
%>
## ----------------------------------------------------------------------------

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${title or default_title} | ${visualization_display_name}</title>

## ----------------------------------------------------------------------------


## ----------------------------------------------------------------------------
${h.css( 'base' )}
${h.stylesheet_link( '/plugins/visualizations/chooser/static/chooser.css' )}

## ----------------------------------------------------------------------------
${h.js( 'libs/jquery/jquery',
        'libs/jquery/jquery.migrate',
        'libs/jquery/jquery-ui',
        'libs/bootstrap',
        'libs/underscore',
        'libs/backbone/backbone',
        'libs/require',
        ## 'mvc/ui'
)}
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
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

    <script type="text/javascript">
    var toto = function(){
        launchApp();
    };
    // Declare all the files here
    require.config({
        baseUrl: "/static/scripts"
    });
    require([
        'mvc/dataset/dataset-choice'
    ], function( DATASET_CHOICE ){
        $(function(){
            var datasetFetch = jQuery.ajax( '/api/histories/' +
                '${ trans.security.encode_id( trans.history.id ) }/contents?details=all' );

            datasetFetch.done( function( datasetJSON, JsCoverageQC ){
                // We get all the Galaxy datasetChoice inputs
                // Vcf input
                var vcfGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Vcf Dataset',
                        selected    : [ ]
                    });
                $( 'body' ).append(vcfGalaxyInput.render().$el);
                vcfGalaxyInput.on('selected', toto);
                // Bed Exon input
                var exonGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                    datasetJSON : datasetJSON,
                    label       : 'Exon dataset',
                    selected    : [ ]
                    }, { where : { extension: 'bed' }});
                // Bed Amplicon input
                var ampliconGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                    datasetJSON : datasetJSON,
                    label       : 'Amplicon dataset',
                    selected    : [ ]
                    }, { where : { extension: 'bed' }});
                // Tsv Variant input
                var variantGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                    datasetJSON : datasetJSON,
                    label       : 'Variant dataset',
                    selected    : [ ]
                });
                // We launch the app with the inputs
                // TODO: Put a parameter name for each one
                //launchApp();
            });
        });
    });
    </script>
</body>