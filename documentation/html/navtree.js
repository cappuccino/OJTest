var NAVTREE =
[
  [ "Objective-J Test API", "index.html", [
    [ "Class List", "annotated.html", [
      [ "CPArray", "class_c_p_array.html", null ],
      [ "CPInvocation", "class_c_p_invocation.html", null ],
      [ "OJAssert", "class_o_j_assert.html", null ],
      [ "OJMoq", "class_o_j_moq.html", null ],
      [ "OJMoqAssert", "class_o_j_moq_assert.html", null ],
      [ "OJMoqMock", "class_o_j_moq_mock.html", null ],
      [ "OJMoqSpy", "class_o_j_moq_spy.html", null ],
      [ "OJMoqStub", "class_o_j_moq_stub.html", null ],
      [ "OJTestCase", "class_o_j_test_case.html", null ],
      [ "OJTestFailure", "class_o_j_test_failure.html", null ],
      [ "OJTestListenerText", "class_o_j_test_listener_text.html", null ],
      [ "OJTestResult", "class_o_j_test_result.html", null ],
      [ "OJTestRunnerText", "class_o_j_test_runner_text.html", null ],
      [ "OJTestRunnerTextParallel", "class_o_j_test_runner_text_parallel.html", null ],
      [ "OJTestSuite", "class_o_j_test_suite.html", null ],
      [ "OJThread", "class_o_j_thread.html", null ]
    ] ],
    [ "Class Index", "classes.html", null ],
    [ "Class Members", "functions.html", null ],
    [ "File List", "files.html", [
      [ "Frameworks/OJMoq/CPArray+DeepEqual.j", "_c_p_array_09_deep_equal_8j.html", null ],
      [ "Frameworks/OJMoq/CPArray+Find.j", "_c_p_array_09_find_8j.html", null ],
      [ "Frameworks/OJMoq/CPInvocation+Arguments.j", "_c_p_invocation_09_arguments_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoq.j", "_o_j_moq_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoqAssert.j", "_o_j_moq_assert_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoqMock.j", "_o_j_moq_mock_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoqSelector.j", "_o_j_moq_selector_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoqSpy.j", "_o_j_moq_spy_8j.html", null ],
      [ "Frameworks/OJMoq/OJMoqStub.j", "_o_j_moq_stub_8j.html", null ],
      [ "Frameworks/OJUnit/OJAssert.j", "_o_j_assert_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestCase+Assert.j", "_o_j_test_case_09_assert_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestCase.j", "_o_j_test_case_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestFailure.j", "_o_j_test_failure_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestListenerText.j", "_o_j_test_listener_text_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestResult.j", "_o_j_test_result_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestRunnerText.j", "_o_j_test_runner_text_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestRunnerTextParallel.j", "_o_j_test_runner_text_parallel_8j.html", null ],
      [ "Frameworks/OJUnit/OJTestSuite.j", "_o_j_test_suite_8j.html", null ]
    ] ],
    [ "File Members", "globals.html", null ]
  ] ]
];

function createIndent(o,domNode,node,level)
{
  if (node.parentNode && node.parentNode.parentNode)
  {
    createIndent(o,domNode,node.parentNode,level+1);
  }
  var imgNode = document.createElement("img");
  if (level==0 && node.childrenData)
  {
    node.plus_img = imgNode;
    node.expandToggle = document.createElement("a");
    node.expandToggle.href = "javascript:void(0)";
    node.expandToggle.onclick = function() 
    {
      if (node.expanded) 
      {
        $(node.getChildrenUL()).slideUp("fast");
        if (node.isLast)
        {
          node.plus_img.src = node.relpath+"ftv2plastnode.png";
        }
        else
        {
          node.plus_img.src = node.relpath+"ftv2pnode.png";
        }
        node.expanded = false;
      } 
      else 
      {
        expandNode(o, node, false);
      }
    }
    node.expandToggle.appendChild(imgNode);
    domNode.appendChild(node.expandToggle);
  }
  else
  {
    domNode.appendChild(imgNode);
  }
  if (level==0)
  {
    if (node.isLast)
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2plastnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2lastnode.png";
        domNode.appendChild(imgNode);
      }
    }
    else
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2pnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2node.png";
        domNode.appendChild(imgNode);
      }
    }
  }
  else
  {
    if (node.isLast)
    {
      imgNode.src = node.relpath+"ftv2blank.png";
    }
    else
    {
      imgNode.src = node.relpath+"ftv2vertline.png";
    }
  }
  imgNode.border = "0";
}

function newNode(o, po, text, link, childrenData, lastNode)
{
  var node = new Object();
  node.children = Array();
  node.childrenData = childrenData;
  node.depth = po.depth + 1;
  node.relpath = po.relpath;
  node.isLast = lastNode;

  node.li = document.createElement("li");
  po.getChildrenUL().appendChild(node.li);
  node.parentNode = po;

  node.itemDiv = document.createElement("div");
  node.itemDiv.className = "item";

  node.labelSpan = document.createElement("span");
  node.labelSpan.className = "label";

  createIndent(o,node.itemDiv,node,0);
  node.itemDiv.appendChild(node.labelSpan);
  node.li.appendChild(node.itemDiv);

  var a = document.createElement("a");
  node.labelSpan.appendChild(a);
  node.label = document.createTextNode(text);
  a.appendChild(node.label);
  if (link) 
  {
    a.href = node.relpath+link;
  } 
  else 
  {
    if (childrenData != null) 
    {
      a.className = "nolink";
      a.href = "javascript:void(0)";
      a.onclick = node.expandToggle.onclick;
      node.expanded = false;
    }
  }

  node.childrenUL = null;
  node.getChildrenUL = function() 
  {
    if (!node.childrenUL) 
    {
      node.childrenUL = document.createElement("ul");
      node.childrenUL.className = "children_ul";
      node.childrenUL.style.display = "none";
      node.li.appendChild(node.childrenUL);
    }
    return node.childrenUL;
  };

  return node;
}

function showRoot()
{
  var headerHeight = $("#top").height();
  var footerHeight = $("#nav-path").height();
  var windowHeight = $(window).height() - headerHeight - footerHeight;
  navtree.scrollTo('#selected',0,{offset:-windowHeight/2});
}

function expandNode(o, node, imm)
{
  if (node.childrenData && !node.expanded) 
  {
    if (!node.childrenVisited) 
    {
      getNode(o, node);
    }
    if (imm)
    {
      $(node.getChildrenUL()).show();
    } 
    else 
    {
      $(node.getChildrenUL()).slideDown("fast",showRoot);
    }
    if (node.isLast)
    {
      node.plus_img.src = node.relpath+"ftv2mlastnode.png";
    }
    else
    {
      node.plus_img.src = node.relpath+"ftv2mnode.png";
    }
    node.expanded = true;
  }
}

function getNode(o, po)
{
  po.childrenVisited = true;
  var l = po.childrenData.length-1;
  for (var i in po.childrenData) 
  {
    var nodeData = po.childrenData[i];
    po.children[i] = newNode(o, po, nodeData[0], nodeData[1], nodeData[2],
        i==l);
  }
}

function findNavTreePage(url, data)
{
  var nodes = data;
  var result = null;
  for (var i in nodes) 
  {
    var d = nodes[i];
    if (d[1] == url) 
    {
      return new Array(i);
    }
    else if (d[2] != null) // array of children
    {
      result = findNavTreePage(url, d[2]);
      if (result != null) 
      {
        return (new Array(i).concat(result));
      }
    }
  }
  return null;
}

function initNavTree(toroot,relpath)
{
  var o = new Object();
  o.toroot = toroot;
  o.node = new Object();
  o.node.li = document.getElementById("nav-tree-contents");
  o.node.childrenData = NAVTREE;
  o.node.children = new Array();
  o.node.childrenUL = document.createElement("ul");
  o.node.getChildrenUL = function() { return o.node.childrenUL; };
  o.node.li.appendChild(o.node.childrenUL);
  o.node.depth = 0;
  o.node.relpath = relpath;

  getNode(o, o.node);

  o.breadcrumbs = findNavTreePage(toroot, NAVTREE);
  if (o.breadcrumbs == null)
  {
    o.breadcrumbs = findNavTreePage("index.html",NAVTREE);
  }
  if (o.breadcrumbs != null && o.breadcrumbs.length>0)
  {
    var p = o.node;
    for (var i in o.breadcrumbs) 
    {
      var j = o.breadcrumbs[i];
      p = p.children[j];
      expandNode(o,p,true);
    }
    p.itemDiv.className = p.itemDiv.className + " selected";
    p.itemDiv.id = "selected";
    $(window).load(showRoot);
  }
}

