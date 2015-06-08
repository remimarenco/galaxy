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
        // Declare all the files here
        require.config({
        baseUrl: "/static/scripts"
    });
    require([
        'mvc/dataset/dataset-choice'
    ], function( DATASET_CHOICE ){

        //$(function(){
        //    var datasetFetch = jQuery.ajax( '/api/histories/${ history_id }/contents?details=all' );
        //    datasetFetch.done( function( datasetJSON ){
        //        ( new DATASET_CHOICE.DatasetChoiceModal( datasetJSON, {
        //
        //        })).done( function(){
        //
        //        });
        //    });
        //});
        //

        $(function(){
            var datasetFetch = jQuery.ajax( '/api/histories/' +
                '${ trans.security.encode_id( trans.history.id ) }/contents?details=all' );

            datasetFetch.done( function( datasetJSON ){
                // Replace the HTML5 inputs by DatasetChoices

                var vcfGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Vcf Dataset',
                        selected    : [ ]
                    });
                vcfGalaxyInput.on( 'selected', function( chooser, json ){
                    debugger;
                });
                $( '#vcfFile' ).replaceWith([
                    vcfGalaxyInput.render().$el
                ]);

                $( '#exonFile' ).replaceWith(
                    new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Exon dataset',
                        selected    : [ ]
                    }, { where : { extension: 'bed' }}).render().$el
                );

                $( '#ampliconFile' ).replaceWith(
                    new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Amplicon dataset',
                        selected    : [ ]
                    }).render().$el
                );

                $( '#variantTsv' ).replaceWith(
                    new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Variant dataset',
                        selected    : [ ]
                    }).render().$el
                );

                $( '#doNotCallFile' ).replaceWith(
                    new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'DoNotCall dataset',
                        selected    : [ ]
                    }).render().$el
                );
            });

        });
    });
    </script>

</body>