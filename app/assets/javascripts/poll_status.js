$( document ).ready(function() {
    setInterval(function(){
        var $tripId = $('#tripStatus').data('id');
        if($tripId){
        $.ajax({ url: '/trips/' + $tripId +'/status/', success: function(data){
            $('#tripStatus').text('Status: ' + data.status + ' at ' + data.time);
            console.log(data);
        }});
    }}, 3000);
});
