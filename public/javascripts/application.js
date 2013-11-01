$(function () {
  var table, visualSearch
  
  var asInitVals = new Array();

  visualSearch = VS.init({
    container : $('.visualsearch'),
    query     : '',
    showFacets : false,
    callbacks : {
      search: function() {
        table.fnDraw()
      },
      facetMatches: function(callback) {
        callback(['Client', 'Product', 'Destination', 'Carrier', 'Currency'])
      },
      valueMatches: function(facet, searchTerm, callback) {
        switch (facet) {
          case 'Client': callback(['CLX', 'Infobip', 'Kieser', 'Nokia']); break
          case 'Product': callback(['GlobalTxt']); break
          case 'Destination': callback(['France', 'Germany', 'Spain', 'UK', 'USA']); break
          case 'Carrier': callback(['ATT', 'O2', 'Verizon', 'Vodafone']); break
          case 'Currency': callback(['AUD', 'EUR', 'GBP', 'USD']); break
        }
      }
    }
  })

  table = $('table#languages').dataTable({
    /*"oLanguage": {
      "sSearch": "Search all columns:"
    },*/
    "sDom": 'Rlfrtip',          // Column reordering
    "bStateSave": true,         // Column order state save in cookies
    bFilter: false,
    bInfo: true,                // Displays "Showing X of Y entries"
    bLengthChange: false,
    iDisplayLength: 50,
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: 'list.json',
    fnServerParams: function (aoData) {
      var facets = visualSearch.searchQuery.facets()

      $.each(facets, function (index, facet) {
        var name  = _.keys(facet)[0],
            value = _.values(facet)[0]

        aoData.push({
          name: 'search[' + name + '][]',
          value: value
        })
      })
    }
  })
  

    
})
