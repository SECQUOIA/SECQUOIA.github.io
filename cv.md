---
layout: basic
title: CV PDF
nav-menu: false
show_tile: false
---

<section id="cv_pdf">
    <div class="inner">
        <header class="major">
            <h2>Full Curriculum Vitae</h2>
        </header>
        <ul class="actions">
            <li><a href="aboutme.html" class="button icon fa-arrow-left">Go back to About Me</a></li>
        </ul>
        <div id="adobe-dc-view" style="width: 100%;"></div>
        <script src="https://documentservices.adobe.com/view-sdk/viewer.js"></script>
        <script type="text/javascript">
            document.addEventListener("adobe_dc_view_sdk.ready", function(){ 
                var adobeDCView = new AdobeDC.View({clientId: "a40573442f804376b6158bb8d98858ee", divId: "adobe-dc-view"});
                adobeDCView.previewFile({
                    content:{location: {url: "assets/pdfs/cv.pdf"}},
                    metaData:{fileName: "cv.pdf"}
                }, {embedMode: "IN_LINE", showDownloadPDF: true});
            });
        </script>
        <ul class="actions">
            <li><a href="aboutme.html" class="button icon fa-arrow-left">Go back to About Me</a></li>
        </ul>
    </div>
</section>