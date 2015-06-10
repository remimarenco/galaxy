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
<script type="text/javascript"
        src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1','packages':['corechart']}]}">
        </script>

</head>

## ----------------------------------------------------------------------------
<body>
    <div id="data-controls">
        <button id="process" disabled>Process</button>
    </div>
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
        $(function(){
            var datasetFetch = jQuery.ajax( '/api/histories/' +
                '${ trans.security.encode_id( trans.history.id ) }/contents?details=all' );

            datasetFetch.done( function( datasetJSON ){
                // We get all the Galaxy datasetChoice inputs
                // Vcf input
                var vcfGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Vcf Dataset',
                        selected    : [ '${query.get( "dataset_id" )}' ],
                        // where       : { file_ext: 'vcf', state: 'ok' }
                    });
                // Bed Exon input
                var exonGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Exon dataset',
                        // where       : { file_ext: 'bed', state: 'ok' }
                    });
                // Bed Amplicon input
                var ampliconGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Amplicon dataset',
                        // where       : { file_ext: 'bed', state: 'ok' }
                    });
                // Tsv Variant input
                var variantGalaxyInput = new DATASET_CHOICE.DatasetChoice({
                        datasetJSON : datasetJSON,
                        label       : 'Variant dataset',
                        // where       : { file_ext: 'tsv', state: 'ok' }
                    });

                function onDatasetSelect(){
                    // if the main four are selected, enable the process button
                    if( vcfGalaxyInput.selected &&
                        exonGalaxyInput.selected &&
                        ampliconGalaxyInput.selected &&
                        variantGalaxyInput.selected ){
                        $( '#process' ).prop( 'disabled', false );
                    }
                }
                var $inputs = [ vcfGalaxyInput, exonGalaxyInput, ampliconGalaxyInput, variantGalaxyInput ];
                $inputs = $inputs.map( function( input ){
                    input.on( 'selected', onDatasetSelect );
                    return input.render().$el;
                });
                $( '#data-controls' ).prepend( $inputs );

                function process(){
                    // fetch the raw data from the datasets web controller
                    jQuery.when(
                        jQuery.get( '/datasets/' + vcfGalaxyInput.selected + '/display' ),
                        jQuery.get( '/datasets/' + exonGalaxyInput.selected + '/display' ),
                        jQuery.get( '/datasets/' + ampliconGalaxyInput.selected + '/display' ),
                        jQuery.get( '/datasets/' + variantGalaxyInput.selected + '/display' )

                    ).done( function( vcfResponse, exonResponse, ampliconResponse, variantResponse ){
                        // vcfResponse[1] is generally success, [2] is the XHR
                        var filedata = {
                            vcf : vcfResponse[0],
                            exon : exonResponse[0],
                            amplicon : ampliconResponse[0],
                            variant : variantResponse[0]
                        };
                        // !! ... do something with the data + your app
                        var myGalaxyParameters = {
                            needHtml5Upload: false,
                            vcfGalaxyResult: filedata.vcf,
                            exonGalaxyResult: filedata.exon,
                            ampliconGalaxyResult: filedata.amplicon,
                            variantGalaxyResult: filedata.variant
                        };
                        launchApp( myGalaxyParameters );
                        /*console.debug( filedata.vcf );
                        console.debug( filedata.exon );
                        console.debug( filedata.amplicon );
                        console.debug( filedata.variant );
                        */
                    });
                    // .fail( function(){ /* handle errors */ })
                }
                $( '#process' ).on( 'click', process );
            });
        });
    });
    </script>
</body>