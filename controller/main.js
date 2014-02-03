/**
 * Created with IntelliJ IDEA.
 * User: eyin
 * Date: 1/8/14
 * Time: 2:48 PM
 * To change this template use File | Settings | File Templates.
 */
var fleetArray = [{title:'ONLINE'},{title:'OFFLINE'}];
var manualArray =  [{title:'HTML'},{title:'PDF'},{title:'XML'}];
var openPageTitle = "";
var openPages = [];

var HTMLUrl =
   // "https://aaemanualmobile.aviationzone.net/ietpmobile/exec/contentLoad.aspx?VERSION=CURRENT&DOCNBR=737_AMM&DOCTYPE=AMM&MODEL=B737&REFKEY=FF23ADB810917706C7C4959BFAF16EAE&CONTEXT=TABLET"
 //"https://aaemanualmobile.aviationzone.net/ietpmobile/exec/contentLoad.aspx?VERSION=CURRENT&DOCNBR=737_AMM&DOCTYPE=AMM&MODEL=B737&REFKEY=A22F077A0A8F0652289C38FA1B7A726A&CONTEXT=TABLET";
    "http://192.168.5.125/ietp_tablet/exec/contentLoad.aspx?VERSION=current&DOCNBR=AAL_737_800_AMM_R47_021512&DOCTYPE=AMM&MODEL=AAL_737&REFKEY=IF4DE5CF61E543C56A6E38AF6EDAB112&CONTEXT=TABLET";

var HTMLPath = "infotrust/POC/sample.html";
//"infotrust/POC/sample.html";
var PDFUrl =
    //"http://192.168.5.125/ietp_tablet/help/IETP_ATA_USER_GUIDE.pdf";
    "http://cdn.mozilla.net/pdfjs/tracemonkey.pdf";

var PDFPath =  "/../infotrust/POC/sample.pdf";
var XMLUrl =
    "http://192.168.5.125/ietp_tablet/www/stylesheets/sample.xml";
var XMLPath = "infotrust/POC/sample.xml";
    //"http://192.168.5.125/ietp_tablet/www/NN-2-12-11.xml";
var XSLUrl =
    "stylesheets/sample.xsl";
   //"stylesheets/fcom/FCOM.xsl";
var XSLPath = "sample.xsl";

var appModule = angular.module('myapp', ['ngPDFViewer']);

(function(){
 window.appRootDirName = ".myapp";
 document.addEventListener("deviceready", onDeviceReady, false);
 
 function onDeviceReady() {
 console.log("device is ready");
 window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem;
 window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, gotFS, fail);
 }
 
 function fail() {
 console.log("failed to get filesystem");
 }
 
 function gotFS(fileSystem) {
 console.log("filesystem got");
 fileSystem.root.getDirectory(window.appRootDirName, {
                              create : true,
                              exclusive : false
                              }, dirReady, fail);
 }
 
 function dirReady(entry) {
 window.appRootDir = entry;
 console.log(JSON.stringify(window.appRootDir));
 }
 })();


//appModule.controller('bodycontroller', [ '$scope', 'PDFViewerService', function($scope,$http,$sce, pdf) {
appModule.controller('bodycontroller',function($scope,$http,$sce) {
    $scope.fleets = fleetArray;
    $scope.toggleManuals = function(status){

        $scope.status = status;

        $scope.manuals = manualArray;


}
    $scope.openManual = function(ManualType){
        if( $scope.status == "ONLINE"){
            eval("$scope."+ManualType+"Url"+"="+ManualType+"Url");
                     eval("$scope."+ManualType+"Path"+"='null'");
                     

        }else if( $scope.status == "OFFLINE"){
            eval("$scope."+ManualType+"Path"+"="+ManualType+"Path");
                      eval("$scope."+ManualType+"Url"+"='null'");
        }

        if(openPageTitle.indexOf(ManualType)<0){
            openPageTitle += ManualType;
           openPages.push({title:ManualType});
            $scope.pages = openPages;
        }
       // $scope.aipcUrl = "http://192.168.5.125/ietp_tablet/exec/contentLoad.aspx?VERSION=current&DOCNBR=AAL_737-800_IPC_R44_021512&DOCTYPE=AIPC&MODEL=AAL_737&REFKEY=K22111101&CONTEXT=TABLET";
    }
    $scope.$watch('status', function(newValue, oldValue) {
        if(newValue){
                  //if(newValue != oldValue){
                  //alert(newValue+" "+oldValue)
       
                    $scope.trustedHtml = "<div/>";
                    $scope.trustedXmlHtml = "<div/>";
                   document.getElementById("trustedXmlHtml").innerHTML = "<div/>";
                   document.getElementById("trustedHtml").innerHTML = "<div/>";

                  //}
        }
    });

    $scope.$watch('HTMLUrl', function(newValue, oldValue) {
        if(newValue){
            fetchAmmHtmlData(newValue);
        }
    });

    $scope.$watch('HTMLPath', function(newValue, oldValue) {
        if(newValue){
              
            readHtml(newValue,getHtmlContents);
                  onDeviceReady();
        }
    });

    $scope.$watch('XMLUrl', function(newValue, oldValue) {
        if(newValue){
            transformXmlData(newValue);
        }
    });
    $scope.$watch('XMLPath', function(newValue, oldValue) {
        if(newValue){
              readHtml(newValue,xmlReady);
        }
    });
    $scope.download = function(){

        window.requestFileSystem(
            LocalFileSystem.PERSISTENT, 0,
            function onFileSystemSuccess(fileSystem) {
                var sPath = window.appRootDir.fullPath+"/../infotrust/POC/"
                var fileTransfer = new FileTransfer();
                fileTransfer.download(
                    "http://192.168.5.125/ietp_tablet/www/references/sample.html",
                    sPath + "sample.html", function(theFile) {
                              alert("download sample.html complete");
                                console.log("download complete: " + theFile.toURI());
                                //showLink(theFile.toURI());
                            },
                            fail
                );
                fileTransfer.download(
                    "http://192.168.5.125/ietp_tablet/www/references/sample.pdf",
                    sPath + "sample.pdf", function(theFile) {
                        alert("download sample.pdf complete");
                        console.log("download complete: " + theFile.toURI());
                        //showLink(theFile.toURI());
                    },
                    fail
                );
                fileTransfer.download(
                    "http://192.168.5.125/ietp_tablet/www/references/sample.xml",
                    sPath + "sample.xml", function(theFile) {
                        alert("download sample.xml complete");
                        console.log("download complete: " + theFile.toURI());
                        //showLink(theFile.toURI());
                    },
                    fail
                );

//                fileSystem.root.getFile(
//                    "infotrust/dummy.html", {create: true, exclusive: false},
//                    function gotFileEntry(fileEntry){
//                        console.log("fullPath="+fileEntry.fullPath) ;
//                        var sPath = window.appRootDir.fullPath+"/../infotrust/"
//                        console.log("sPath="+sPath);
//                        var fileTransfer = new FileTransfer();
//                        fileEntry.remove();
//
//                        fileTransfer.download(
//                            "http://192.168.5.125/ietp_tablet/www/references/sample.html",
//                            sPath + "sample.html",
//                            function(theFile) {
//                                console.log("download complete: " + theFile.toURI());
//                                //showLink(theFile.toURI());
//                            },
//                            function(error) {
//                                console.log("download error source " + error.source);
//                                console.log("download error target " + error.target);
//                                console.log("upload error code: " + error.code);
//                            }
//                        );
//                    },
//                    fail);
            },
            fail);

    }
                     
                     function onDeviceReady() {
                     console.log(window.apRootDir.fullPath);
                     window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, onFileSystemSuccess, fail);
                     }
                     
                     function onFileSystemSuccess(fileSystem) {
                     console.log(fileSystem.name);
                     console.log(fileSystem.root.name);
                     }



    function readHtml(filePath,callback){
        window.requestFileSystem(
            LocalFileSystem.PERSISTENT, 0,
            function onFileSystemSuccess(fileSystem) {
                fileSystem.root.getFile(
                    filePath, {create: false, exclusive: true},
                    function gotFileEntry(fileEntry){
                                    
                        console.log("path 11uri=" + fileEntry.fullPath);
                        console.log("path=" + fileEntry.fullPath.substring(7));
                        fileEntry.file(callback, fail);
                    },
                    fail);
            },
            fail);
    }

    function  xmlReady(file){
        console.log("call xmlready function ");
        var reader = new FileReader();
        reader.onloadend = function (evt) {
        console.log(this.readyState);
        var data = evt.target.result;
            console.log(data);
         var parser = new DOMParser();
         var  xmlDoc = parser.parseFromString(data,"text/xml");
            document.getElementById("trustedXmlHtml").innerHTML = doXslTransform(xmlDoc);
          //  console.log(document.getElementById("trustedXmlHtml").innerHTML);
      //TODO  $scope.trustedXmlHtml = $sce.trustAsHtml(doXslTransform(xmlDoc));
    };
        reader.readAsText(file);
    }

    function getHtmlContents(file) {


        var reader = new FileReader();
        reader.onloadend = function (evt) {

            console.log(this.readyState);
            var data = evt.target.result;
            data=data.slice(data.indexOf('<BODY'),data.indexOf('</BODY>'));
           // $scope.trustedHtml = $sce.trustAsHtml(data);
            document.getElementById("trustedHtml").innerHTML = data;
           // $("#trustedHtml").innerHTML = data;
        //    alert( document.getElementById("trustedHtml").innerHTML)
         //   $("#trustedHtml").innerHTML = data;
           // attachHtmlData(data);

           // $scope.trustedHtml = "<html><body>123</body></html>";

        };
        reader.readAsText(file);
    }

    function fail(error) {
                   //  alert(error.code)
        console.log(error.code);
    }

    function fetchAmmHtmlData (Url){
        $.mobile.loading("show");

        $http.get(Url).success(function (data) {
            attachHtmlData(data);
        })
    }

    function attachHtmlData (data)
    {
           data=data.slice(data.indexOf('<BODY'),data.indexOf('</BODY>'));
           $scope.trustedHtml = $sce.trustAsHtml(data);

    }



    function loadXmlData(Url){
        var xmlDoc, xmlhttp = null;
        xmlhttp = new XMLHttpRequest();
        xmlDoc =  getXml(Url, xmlhttp).responseXML;
        return xmlDoc;
    }

    function getXml(x, xmlhttp) {
        if (xmlhttp != null) {
            // x = x+"&RAND="+Math.random();
            xmlhttp.open("GET", x, false);
            xmlhttp.setRequestHeader("Host", x);
            xmlhttp.send();

        }
        else {
            alert("Your browser does not support XMLHTTP.11");
            return false;
        }
        return(xmlhttp);
    }

  function doXslTransform(xmlDoc)
  {
      var xslDoc =   xml_loadFile(XSLUrl);
      var ownerDocument = document.implementation.createDocument("", "", null);
      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xslDoc);
      xsltProcessor.setParameter("DOCNBR","FCOM");
      xsltProcessor.setParameter("DOCTYPE","FCOM");
      xsltProcessor.setParameter("MODEL","FCOM");
      xsltProcessor.setParameter("VERSION","CURRENT");
      var result = xsltProcessor.transformToDocument(xmlDoc,document);
     // console.log(result);
      var xmls = new XMLSerializer();
      return  xmls.serializeToString(result)
  }


    function transformXmlData(Url){
        $http.get(Url).success(function (data) {
            try{
                var parser = new DOMParser();
                //var xmlDoc =   xml_loadFile(Url);
                var xmlDoc = parser.parseFromString(data,"text/xml");
                $scope.trustedXmlHtml = $sce.trustAsHtml(doXslTransform(xmlDoc));

            }catch(e)
            {
                alert(e);
            }

       })
    }




});



appModule.controller('TestController', [ '$scope', 'PDFViewerService', function($scope, pdf) {

    $scope.$watch('PDFUrl', function(newValue, oldValue) {
        if(newValue && newValue != "null"){
         
            $scope.pdfURL = encodeURIComponent(PDFUrl);
            //  $scope.pdfURL = "test.pdf"

            $scope.instance = pdf.Instance("viewer");

            $scope.nextPage = function() {
                $scope.instance.nextPage();
            };

            $scope.prevPage = function() {
                $scope.instance.prevPage();
            };
            $scope.pageLoaded = function(curPage, totalPages) {
                $scope.currentPage = curPage;
                $scope.totalPages = totalPages;
            };
            $scope.loadProgress = function(loaded, total, state) {


                console.log('loaded =', loaded, 'total =', total, 'state =', state);
            };
        }
    });
    $scope.$watch('PDFPath', function(newValue, oldValue) {
        if(newValue && newValue != "null"){
       
//            window.requestFileSystem(
//                LocalFileSystem.PERSISTENT, 0,
//                function onFileSystemSuccess(fileSystem) {
//                    fileSystem.root.getFile(
//                        PDFPath, {create: false, exclusive: true}, function gotFileEntry(fileEntry){
//                            $scope.pdfURL = fileEntry.fullPath;
//                            console.log("path uri=" + fileEntry.fullPath);
//                            console.log("path=" + fileEntry.fullPath.substring(7));
//
//                            $scope.pdfURL = encodeURIComponent(fileEntry.fullPath.substring(7));
//                            $scope.instance = pdf.Instance("viewer");
//                        },
//                        fail);
//                },
//                fail);
                  alert(window.appRootDir.fullPath+PDFPath)
            $scope.pdfURL = encodeURIComponent(window.appRootDir.fullPath+PDFPath);
            //  $scope.pdfURL = "test.pdf"
            function fail(error) {
                console.log(error.code);
            }

        //    $scope.gotFileEntry = function (fileEntry){

//            function gotFileEntry(fileEntry){
//                $scope.pdfURL = fileEntry.fullPath;
//                console.log("path uri=" + fileEntry.fullPath);
//                console.log("path=" + fileEntry.fullPath.substring(7));
//
//                $scope.pdfURL = encodeURIComponent(fileEntry.fullPath.substring(7));
//                $scope.instance = pdf.Instance("viewer");
//            }
            $scope.instance = pdf.Instance("viewer");

            $scope.nextPage = function() {
                $scope.instance.nextPage();
            };

            $scope.prevPage = function() {
                $scope.instance.prevPage();
            };
            $scope.pageLoaded = function(curPage, totalPages) {
                $scope.currentPage = curPage;
                $scope.totalPages = totalPages;
            };
            $scope.loadProgress = function(loaded, total, state) {


                console.log('loaded =', loaded, 'total =', total, 'state =', state);
            };
        }
    });


}]);

appModule.controller('fetchAmmHtmlData',function($scope,$http,$sce) {
    $http.get('http://192.168.5.125/ietp_tablet/exec/contentLoad.aspx?VERSION=current&DOCNBR=AAL_737_800_AMM_R47_021512&DOCTYPE=AMM&MODEL=AAL_737&REFKEY=IF4DE5CF61E543C56A6E38AF6EDAB112&CONTEXT=TABLET').success(function (data) {                $scope.sample = data;
        data=data.slice(data.indexOf('<BODY'),data.indexOf('</BODY>'));
        $scope.html =  data;
        $scope.trustedHtml = $sce.trustAsHtml($scope.html);
    })
});


function xml_loadFile(xmlUrl, funcAsync)
{
    var xmlDoc = null;
    var isChrome = false;
    var asyncIs = (null!=funcAsync);
    if (""==xmlUrl)    return null;
    if (asyncIs){
        if ("function"!=typeof(funcAsync))    return null;
    }
    try{
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");    // Support IE
    }
    catch(ex) {}
    if (null==xmlDoc){
        try {
            // Support Firefox, Mozilla, Opera, etc
            xmlDoc = document.implementation.createDocument("", "", null);    // 创建一个空的 XML 文档对象。
        }catch(ex){ }
    }
    if (null==xmlDoc)    return null;
    xmlDoc.async = asyncIs;
    if (asyncIs){
        if(window.ActiveXObject){
            xmlDoc.onreadystatechange = function(){
                if(xmlDoc.readyState == 4) {
                    var isError = false;
                    if (null!=xmlDoc.parseError) {
                        isError = (0!=xmlDoc.parseError.errorCode);    // 0成功, 非0失败。
                    }
                    funcAsync(xmlDoc, isError);
                }
            }
        } else {
            xmlDoc.onload = function(){
                funcAsync(xmlDoc, false);
           }
        }
    }
    try{
        xmlDoc.load(xmlUrl);
    }catch(ex){
        // alert(ex.message)    // 如果浏览器是Chrome，则会catch这个异常：Object # (a Document) has no method "load"
        isChrome = true;
        xmlDoc = null;
    }
    if (isChrome)
    {
        var xhr = new XMLHttpRequest();
        if (asyncIs)    // 异步
        {
            xhr.onreadystatechange = function(){
                if(xhr.readyState == 4)
                {
                    funcAsync(xhr.responseXML, xhr.status != 200);
                }
            }
            xhr.open("GET", xmlUrl, true);
            try {
                xhr.send(null);
            }
            catch(ex) {
                funcAsync(null, true);
                return null;
            }
            return xhr;    // 注意：返回的是XMLHttpRequest。建议异步模式下仅用null测试返回值。
        }
         else    // 同步
        {
            xhr.open("GET", xmlUrl, false);
            xhr.send(null);    // 同步模式下，由调用者处理异常
            xmlDoc = xhr.responseXML;
        }
    }
    return xmlDoc;
}







