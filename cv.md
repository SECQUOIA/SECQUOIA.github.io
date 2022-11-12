---
layout: basic
title: CV PDF
nav-menu: false
show_tile: false
---

<div id="adobe-dc-view"></div>
<script src="https://documentservices.adobe.com/view-sdk/viewer.js"></script>
<script type="text/javascript">
    document.addEventListener("adobe_dc_view_sdk.ready", function(){ 
        var adobeDCView = new AdobeDC.View({clientId: "a40573442f804376b6158bb8d98858ee", divId: "adobe-dc-view"});
        adobeDCView.previewFile({
            content:{location: {url: "assets/pdfs/cv.pdf"}},
            metaData:{fileName: "cv.pdf"}
        }, {embedMode: "FULL_WINDOW"});
    });
</script>