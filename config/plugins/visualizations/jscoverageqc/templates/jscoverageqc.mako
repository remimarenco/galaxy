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
    <ul id="reads">
        %for read in hda.datatype.dataprovider( hda, 'dataset-dict', limit=10 ):
            <li>${read['Chrom']}</li>
        %endfor
        <p id="paragraph"></p>
    </ul>
    <script>
    /* jshint ignore:start */
      __REACT_DEVTOOLS_GLOBAL_HOOK__ = parent.__REACT_DEVTOOLS_GLOBAL_HOOK__;
    /* jshint ignore:end */
    </script>
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
                $( 'body' ).append([
                    new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Input datasets',
                        selected    : [ dataset_id ]
                    }).render().$el
                ]);
            });
        });
    });
    </script>

    ${h.javascript_link( root + 'plugins/visualizations/jscoverageqc/static/assets/main.js' )}

</body>