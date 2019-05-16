<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%@ page import="egovframework.com.cmm.util.EgovUserDetailsHelper"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : EgovLoginPolicyList.java
	 * @Description : EgovLoginPolicyList jsp
	 * @Modification Information
	 * @
	 * @  수정일             수정자              수정내용
	 * @ ---------    --------    ---------------------------
	 * @ 2009.02.01   lee.m.j     최초 생성
	 * @ 2011.09.30   이기하             데이터 없을시 메시지 추가
	 * @ 2018.09.03   신용호             공통컴포넌트 3.8 개선
	 *
	 *  @author lee.m.j
	 *  @since 2009.03.21
	 *  @version 1.0
	 *  @see
	 *
	 *  Copyright (C) 2009 by MOPAS  All right reserved.
	 */
%>

<link href="/skeleton/nifty-v2.9.1/demo/plugins/datatables/media/css/dataTables.bootstrap.css" rel="stylesheet">
<link href="/skeleton/nifty-v2.9.1/demo/plugins/datatables/extensions/Responsive/css/responsive.dataTables.min.css" rel="stylesheet">

<script type="text/javaScript" language="javascript" defer="defer">
	function fncCheckAll() {
		var checkField = document.listForm.delYn;
		if (document.listForm.checkAll.checked) {
			if (checkField) {
				if (checkField.length > 1) {
					for (var i = 0; i < checkField.length; i++) {
						checkField[i].checked = true;
					}
				} else {
					checkField.checked = true;
				}
			}
		} else {
			if (checkField) {
				if (checkField.length > 1) {
					for (var j = 0; j < checkField.length; j++) {
						checkField[j].checked = false;
					}
				} else {
					checkField.checked = false;
				}
			}
		}
	}

	function fncManageChecked() {

		var checkField = document.listForm.delYn;
		var checkId = document.listForm.checkId;
		var returnValue = "";
		var returnBoolean = false;
		var checkCount = 0;

		if (checkField) {
			if (checkField.length > 1) {
				for (var i = 0; i < checkField.length; i++) {
					if (checkField[i].checked) {
						checkCount++;
						checkField[i].value = checkId[i].value;
						if (returnValue == "")
							returnValue = checkField[i].value;
						else
							returnValue = returnValue + ";"
									+ checkField[i].value;
					}
				}
				if (checkCount > 0)
					returnBoolean = true;
				else {
					alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkCount"/>");//선택된  로그인정책이 없습니다.
					returnBoolean = false;
				}
			} else {
				if (document.listForm.delYn.checked == false) {
					alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkCount"/>");//선택된  로그인정책이 없습니다.
					returnBoolean = false;
				} else {
					returnValue = checkId.value;
					returnBoolean = true;
				}
			}
		} else {
			alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkField"/>");//조회된 결과가 없습니다.
		}

		document.listForm.emplyrIds.value = returnValue;
		return returnBoolean;
	}

	function fncSelectLoginPolicyList(pageNo) {
		document.listForm.searchCondition.value = "1";
		document.listForm.pageIndex.value = pageNo;
		document.listForm.action = "<c:url value='/uat/uap/selectLoginPolicyList.do'/>";
		document.listForm.submit();
	}

	function fncSelectLoginPolicy(emplyrId) {
		document.listForm.emplyrId.value = emplyrId;
		document.listForm.action = "<c:url value='/uat/uap/getLoginPolicy.do'/>";
		document.listForm.submit();
	}

	function fncInsertCheckId() {

		var checkedCounter = 0;
		var checkIds = document.listForm.delYn;
		var checkIdv = document.listForm.checkId;
		var checkReg = document.listForm.regYn;

		if (checkIds == null) {
			alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkIds"/>");//조회 후 등록하시기 바랍니다.
			return;
		} else {

			for (var i = 0; i < checkIds.length; i++) {
				if (checkIds[i].checked) {
					if (checkReg[i].value == 'Y') {
						alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkReg"/>");//이미 로그인정책이 등록되어 있습니다.
						return;
					}
					checkedCounter++;
					document.listForm.emplyrId.value = checkIdv[i].value;
				}
			}

			if (checkedCounter > 1) {
				alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkedCounter.onlyOne"/>");//등록대상 하나만 선택하십시오.
				return false;
			} else if (checkedCounter < 1) {
				alert("<spring:message code="comUatUap.LoginPolicyList.validate.checkedCounter.none"/>");//선택된 등록대상이  없습니다.
				return false;
			}

			return true;
		}
	}

	function fncAddLoginPolicyInsert() {

		if (fncInsertCheckId()) {
			document.listForm.action = "<c:url value='/uat/uap/addLoginPolicyView.do'/>";
			document.listForm.submit();
		}
	}

	function fncLoginPolicyListDelete() {
		if (fncManageChecked()) {
			if (confirm("<spring:message code="comUatUap.LoginPolicyList.validate.delete"/>")) {//삭제하시겠습니까?
				document.listForm.action = "<c:url value='/uat/uap/removeLoginPolicyList.do'/>";
				document.listForm.submit();
			}
		}
	}

	function linkPage(pageNo) {
		document.listForm.searchCondition.value = "1";
		document.listForm.pageIndex.value = pageNo;
		document.listForm.action = "<c:url value='/uat/uap/selectLoginPolicyList.do'/>";
		document.listForm.submit();
	}

	function press() {

		if (event.keyCode == 13) {
			fncSelectLoginPolicyList('1');
		}
	}
</script>


<div class="row">
	<div class="panel">
		<div class="panel-heading">
			<h3 class="panel-title">
				<spring:message code="comUatUap.LoginPolicyList.caption" />
			</h3>
		</div>
		<div class="panel-body">

			<!-- Inline Form  -->
			<!--===================================================-->
			<div title="<spring:message code="common.searchCondition.msg" />" class="table-responsive">
				<form name="listForm" action="<c:url value='/uat/uap/selectLoginPolicyList.do'/>" method="post">
					<ul>
						<li><label for=""><spring:message code="comUatUap.LoginPolicyList.userName" /> : </label> <!-- 사용자 명 --> <input class="s_input2 vat" name="searchKeyword" type="text" value="<c:out value="${loginPolicyVO.searchKeyword}"/>" size="25" onkeypress="press();"
							title="<spring:message code="comUatUap.LoginPolicyList.userNameSearch" />" /> <!-- 사용자명검색 --> <input class="s_btn" type="submit" value="<spring:message code="button.inquire" />" title="<spring:message code="title.inquire"/>" onclick="fncSelectLoginPolicyList('1'); return false;" /> <!-- 조회 --></li>
					</ul>
					<input type="hidden" name="emplyrId"> <input type="hidden" name="pageIndex" value="<c:if test="${empty loginPolicyVO.pageIndex }">1</c:if><c:if test="${!empty loginPolicyVO.pageIndex }"><c:out value='${loginPolicyVO.pageIndex}'/></c:if>"> <input type="hidden"
						name="searchCondition" value="1">
				</form>
			</div>
			<!--===================================================-->
			<!-- End Inline Form  -->

		</div>
	</div>
</div>

<div class="row">
	<div class="panel">
		<div class="panel-body">
			<div class="pad-btm form-inline">
				<div class="row">
					<div class="col-sm-6 table-toolbar-left">
						<button id="demo-btn-addrow" class="btn btn-purple">
							<i class="demo-pli-add"></i> Add
						</button>
						<button class="btn btn-default">
							<i class="demo-pli-printer"></i>
						</button>
						<div class="btn-group">
							<button class="btn btn-default">
								<i class="demo-pli-exclamation"></i>
							</button>
							<button class="btn btn-default">
								<i class="demo-pli-recycling"></i>
							</button>
						</div>
					</div>
					<div class="col-sm-6 table-toolbar-right">
						<div class="form-group">
							<input id="demo-input-search2" type="text" placeholder="Search" class="form-control" autocomplete="off">
						</div>
						<div class="btn-group">
							<button class="btn btn-default">
								<i class="demo-pli-download-from-cloud"></i>
							</button>
							<div class="btn-group dropdown">
								<button data-toggle="dropdown" class="btn btn-default dropdown-toggle">
									<i class="demo-pli-gear"></i> <span class="caret"></span>
								</button>
								<ul role="menu" class="dropdown-menu dropdown-menu-right">
									<li><a href="#">Action</a></li>
									<li><a href="#">Another action</a></li>
									<li><a href="#">Something else here</a></li>
									<li class="divider"></li>
									<li><a href="#">Separated link</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="table-responsive">
				<table id="demo-dt-basic" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<caption>
						<spring:message code="comUatUap.LoginPolicyList.caption" />
					</caption>
					<!-- 로그인정책 관리 -->
					<colgroup>
						<col style="width: 10%" />
						<col style="width: 25%" />
						<col style="width: 20%" />
						<col style="width: 15%" />
						<col style="width: 15%" />
					</colgroup>
					<thead>
						<tr>
							<!-- 사용자 ID -->
							<th><spring:message code="comUatUap.LoginPolicyList.userId" /></th>
							<!-- 사용자 명 -->
							<th><spring:message code="comUatUap.LoginPolicyList.userName" /></th>
							<!-- IP 정보 -->
							<th><spring:message code="comUatUap.LoginPolicyList.ipInfo" /></th>
							<!-- 제한여부 -->
							<th><spring:message code="comUatUap.LoginPolicyList.restricted" /></th>
						</tr>
					</thead>
					<tbody>
						<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
						<c:if test="${fn:length(loginPolicyList) == 0}">
							<tr>
								<td colspan="4"><spring:message code="common.nodata.msg" /></td>
							</tr>
						</c:if>
						<c:forEach var="loginPolicy" items="${loginPolicyList}" varStatus="status">
							<tr>
								<form name="item" action="<c:url value='/uat/uap/getLoginPolicy.do'/>">
								<input type="hidden" name="emplyrId" value="<c:out value="${loginPolicy.emplyrId}"/>"> 
								<input type="hidden" name="pageIndex" value="<c:out value='${loginPolicyVO.pageIndex}'/>"> 
								<input type="hidden" name="searchCondition"	value="<c:out value='${loginPolicyVO.searchCondition}'/>"> 
								<input type="hidden" name="searchKeyword" value="<c:out value="${loginPolicyVO.searchKeyword}"/>"> 
								<td>
									<c:out value="${loginPolicy.emplyrId}"/>
<%-- 												
									<div class="label label-table label-success">
											<span class="link ac"> 
												<a href="#" onclick="fncSelectLoginPolicy('<c:out value="${loginPolicy.emplyrId}"/>'); return false;">
													<c:out value="${loginPolicy.emplyrId}"/>
												</a>
													<input class="label label-table label-success" 
														type="submit" 
														value="<c:out value="${loginPolicy.emplyrId}"/>" 
														onclick="fncSelectLoginPolicy('<c:out value="${loginPolicy.emplyrId}"/>'); return false;"
													> 
--%>
											</span>
									</div>
								</td>
								<td><c:out value="${loginPolicy.emplyrNm}" /></td>
								<td><c:out value="${loginPolicy.ipInfo}" /></td>
								<td><c:if test="${loginPolicy.lmttAt == 'Y'}">Y</c:if> <c:if test="${loginPolicy.lmttAt == 'N'}">N</c:if></td>
								</form>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<!-- paging navigation -->
			<c:if test="${!empty loginPolicyVO.pageIndex }">
				<div class="pagination">
					<ul>
						<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="linkPage" />
					</ul>
				</div>
			</c:if>
		</div>
	</div>
</div>



<div class="row">
	<div class="panel">
		<div class="panel-body">
			<table class="board_list">
				<caption>
					<spring:message code="comUatUap.LoginPolicyList.caption" />
				</caption>
				<!-- 로그인정책 관리 -->
				<colgroup>
					<col style="width: 20%" />
					<col style="width: 25%" />
					<col style="width: 20%" />
					<col style="width: 15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><spring:message code="comUatUap.LoginPolicyList.userId" /></th>
						<!-- 사용자 ID -->
						<th scope="col"><spring:message code="comUatUap.LoginPolicyList.userName" /></th>
						<!-- 사용자 명 -->
						<th scope="col"><spring:message code="comUatUap.LoginPolicyList.ipInfo" /></th>
						<!-- IP 정보 -->
						<th scope="col"><spring:message code="comUatUap.LoginPolicyList.restricted" /></th>
						<!-- 제한여부 -->
					</tr>
				</thead>
				<tbody>
					<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
					<c:if test="${fn:length(loginPolicyList) == 0}">
						<tr>
							<td colspan="4"><spring:message code="common.nodata.msg" /></td>
						</tr>
					</c:if>
					<c:forEach var="loginPolicy" items="${loginPolicyList}" varStatus="status">
						<tr>
							<td>
								<form name="item" action="<c:url value='/uat/uap/getLoginPolicy.do'/>">
									<input type="hidden" name="emplyrId" value="<c:out value="${loginPolicy.emplyrId}"/>"> <input type="hidden" name="pageIndex" value="<c:out value='${loginPolicyVO.pageIndex}'/>"> <input type="hidden" name="searchCondition"
										value="<c:out value='${loginPolicyVO.searchCondition}'/>"> <input type="hidden" name="searchKeyword" value="<c:out value="${loginPolicyVO.searchKeyword}"/>"> <span class="link ac"><input type="submit" value="<c:out value="${loginPolicy.emplyrId}"/>"
										onclick="fncSelectLoginPolicy('<c:out value="${loginPolicy.emplyrId}"/>'); return false;"></span>
								</form>
							</td>
							<td><c:out value="${loginPolicy.emplyrNm}" /></td>
							<td><c:out value="${loginPolicy.ipInfo}" /></td>
							<td><c:if test="${loginPolicy.lmttAt == 'Y'}">Y</c:if> <c:if test="${loginPolicy.lmttAt == 'N'}">N</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<!-- paging navigation -->
			<c:if test="${!empty loginPolicyVO.pageIndex }">
				<div class="pagination">
					<ul>
						<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="linkPage" />
					</ul>
				</div>
			</c:if>

		</div>
	</div>
</div>

					<!-- Basic Data Tables -->
					<!--===================================================-->
					<div class="panel">
					    <div class="panel-heading">
					        <h3 class="panel-title">Basic Data Tables with responsive plugin</h3>
					    </div>
					    <div class="panel-body">
					        <table id="demo-dt-basic" class="table table-striped table-bordered" cellspacing="0" width="100%">
					            <thead>
					                <tr>
					                    <th>Name</th>
					                    <th>Position</th>
					                    <th class="min-tablet">Office</th>
					                    <th class="min-tablet">Extn.</th>
					                    <th class="min-desktop">Start date</th>
					                    <th class="min-desktop">Salary</th>
					                </tr>
					            </thead>
					            <tbody>
					                <tr>
					                    <td>Tiger Nixon</td>
					                    <td>System Architect</td>
					                    <td>Edinburgh</td>
					                    <td>61</td>
					                    <td>2011/04/25</td>
					                    <td>$320,800</td>
					                </tr>
					                <tr>
					                    <td>Garrett Winters</td>
					                    <td>Accountant</td>
					                    <td>Tokyo</td>
					                    <td>63</td>
					                    <td>2011/07/25</td>
					                    <td>$170,750</td>
					                </tr>
					                <tr>
					                    <td>Ashton Cox</td>
					                    <td>Junior Technical Author</td>
					                    <td>San Francisco</td>
					                    <td>66</td>
					                    <td>2009/01/12</td>
					                    <td>$86,000</td>
					                </tr>
					                <tr>
					                    <td>Cedric Kelly</td>
					                    <td>Senior Javascript Developer</td>
					                    <td>Edinburgh</td>
					                    <td>22</td>
					                    <td>2012/03/29</td>
					                    <td>$433,060</td>
					                </tr>
					                <tr>
					                    <td>Airi Satou</td>
					                    <td>Accountant</td>
					                    <td>Tokyo</td>
					                    <td>33</td>
					                    <td>2008/11/28</td>
					                    <td>$162,700</td>
					                </tr>
					                <tr>
					                    <td>Brielle Williamson</td>
					                    <td>Integration Specialist</td>
					                    <td>New York</td>
					                    <td>61</td>
					                    <td>2012/12/02</td>
					                    <td>$372,000</td>
					                </tr>
					                <tr>
					                    <td>Herrod Chandler</td>
					                    <td>Sales Assistant</td>
					                    <td>San Francisco</td>
					                    <td>59</td>
					                    <td>2012/08/06</td>
					                    <td>$137,500</td>
					                </tr>
					                <tr>
					                    <td>Rhona Davidson</td>
					                    <td>Integration Specialist</td>
					                    <td>Tokyo</td>
					                    <td>55</td>
					                    <td>2010/10/14</td>
					                    <td>$327,900</td>
					                </tr>
					                <tr>
					                    <td>Colleen Hurst</td>
					                    <td>Javascript Developer</td>
					                    <td>San Francisco</td>
					                    <td>39</td>
					                    <td>2009/09/15</td>
					                    <td>$205,500</td>
					                </tr>
					                <tr>
					                    <td>Sonya Frost</td>
					                    <td>Software Engineer</td>
					                    <td>Edinburgh</td>
					                    <td>23</td>
					                    <td>2008/12/13</td>
					                    <td>$103,600</td>
					                </tr>
					                <tr>
					                    <td>Jena Gaines</td>
					                    <td>Office Manager</td>
					                    <td>London</td>
					                    <td>30</td>
					                    <td>2008/12/19</td>
					                    <td>$90,560</td>
					                </tr>
					                <tr>
					                    <td>Quinn Flynn</td>
					                    <td>Support Lead</td>
					                    <td>Edinburgh</td>
					                    <td>22</td>
					                    <td>2013/03/03</td>
					                    <td>$342,000</td>
					                </tr>
					                <tr>
					                    <td>Charde Marshall</td>
					                    <td>Regional Director</td>
					                    <td>San Francisco</td>
					                    <td>36</td>
					                    <td>2008/10/16</td>
					                    <td>$470,600</td>
					                </tr>
					                <tr>
					                    <td>Haley Kennedy</td>
					                    <td>Senior Marketing Designer</td>
					                    <td>London</td>
					                    <td>43</td>
					                    <td>2012/12/18</td>
					                    <td>$313,500</td>
					                </tr>
					                <tr>
					                    <td>Tatyana Fitzpatrick</td>
					                    <td>Regional Director</td>
					                    <td>London</td>
					                    <td>19</td>
					                    <td>2010/03/17</td>
					                    <td>$385,750</td>
					                </tr>
					                <tr>
					                    <td>Michael Silva</td>
					                    <td>Marketing Designer</td>
					                    <td>London</td>
					                    <td>66</td>
					                    <td>2012/11/27</td>
					                    <td>$198,500</td>
					                </tr>
					                <tr>
					                    <td>Paul Byrd</td>
					                    <td>Chief Financial Officer (CFO)</td>
					                    <td>New York</td>
					                    <td>64</td>
					                    <td>2010/06/09</td>
					                    <td>$725,000</td>
					                </tr>
					                <tr>
					                    <td>Gloria Little</td>
					                    <td>Systems Administrator</td>
					                    <td>New York</td>
					                    <td>59</td>
					                    <td>2009/04/10</td>
					                    <td>$237,500</td>
					                </tr>
					                <tr>
					                    <td>Bradley Greer</td>
					                    <td>Software Engineer</td>
					                    <td>London</td>
					                    <td>41</td>
					                    <td>2012/10/13</td>
					                    <td>$132,000</td>
					                </tr>
					                <tr>
					                    <td>Dai Rios</td>
					                    <td>Personnel Lead</td>
					                    <td>Edinburgh</td>
					                    <td>35</td>
					                    <td>2012/09/26</td>
					                    <td>$217,500</td>
					                </tr>
					                <tr>
					                    <td>Jenette Caldwell</td>
					                    <td>Development Lead</td>
					                    <td>New York</td>
					                    <td>30</td>
					                    <td>2011/09/03</td>
					                    <td>$345,000</td>
					                </tr>
					                <tr>
					                    <td>Yuri Berry</td>
					                    <td>Chief Marketing Officer (CMO)</td>
					                    <td>New York</td>
					                    <td>40</td>
					                    <td>2009/06/25</td>
					                    <td>$675,000</td>
					                </tr>
					                <tr>
					                    <td>Caesar Vance</td>
					                    <td>Pre-Sales Support</td>
					                    <td>New York</td>
					                    <td>21</td>
					                    <td>2011/12/12</td>
					                    <td>$106,450</td>
					                </tr>
					                <tr>
					                    <td>Doris Wilder</td>
					                    <td>Sales Assistant</td>
					                    <td>Sidney</td>
					                    <td>23</td>
					                    <td>2010/09/20</td>
					                    <td>$85,600</td>
					                </tr>
					                <tr>
					                    <td>Angelica Ramos</td>
					                    <td>Chief Executive Officer (CEO)</td>
					                    <td>London</td>
					                    <td>47</td>
					                    <td>2009/10/09</td>
					                    <td>$1,200,000</td>
					                </tr>
					                <tr>
					                    <td>Gavin Joyce</td>
					                    <td>Developer</td>
					                    <td>Edinburgh</td>
					                    <td>42</td>
					                    <td>2010/12/22</td>
					                    <td>$92,575</td>
					                </tr>
					                <tr>
					                    <td>Jennifer Chang</td>
					                    <td>Regional Director</td>
					                    <td>Singapore</td>
					                    <td>28</td>
					                    <td>2010/11/14</td>
					                    <td>$357,650</td>
					                </tr>
					                <tr>
					                    <td>Brenden Wagner</td>
					                    <td>Software Engineer</td>
					                    <td>San Francisco</td>
					                    <td>28</td>
					                    <td>2011/06/07</td>
					                    <td>$206,850</td>
					                </tr>
					                <tr>
					                    <td>Fiona Green</td>
					                    <td>Chief Operating Officer (COO)</td>
					                    <td>San Francisco</td>
					                    <td>48</td>
					                    <td>2010/03/11</td>
					                    <td>$850,000</td>
					                </tr>
					                <tr>
					                    <td>Shou Itou</td>
					                    <td>Regional Marketing</td>
					                    <td>Tokyo</td>
					                    <td>20</td>
					                    <td>2011/08/14</td>
					                    <td>$163,000</td>
					                </tr>
					                <tr>
					                    <td>Michelle House</td>
					                    <td>Integration Specialist</td>
					                    <td>Sidney</td>
					                    <td>37</td>
					                    <td>2011/06/02</td>
					                    <td>$95,400</td>
					                </tr>
					                <tr>
					                    <td>Suki Burks</td>
					                    <td>Developer</td>
					                    <td>London</td>
					                    <td>53</td>
					                    <td>2009/10/22</td>
					                    <td>$114,500</td>
					                </tr>
					                <tr>
					                    <td>Prescott Bartlett</td>
					                    <td>Technical Author</td>
					                    <td>London</td>
					                    <td>27</td>
					                    <td>2011/05/07</td>
					                    <td>$145,000</td>
					                </tr>
					                <tr>
					                    <td>Gavin Cortez</td>
					                    <td>Team Leader</td>
					                    <td>San Francisco</td>
					                    <td>22</td>
					                    <td>2008/10/26</td>
					                    <td>$235,500</td>
					                </tr>
					                <tr>
					                    <td>Martena Mccray</td>
					                    <td>Post-Sales support</td>
					                    <td>Edinburgh</td>
					                    <td>46</td>
					                    <td>2011/03/09</td>
					                    <td>$324,050</td>
					                </tr>
					                <tr>
					                    <td>Unity Butler</td>
					                    <td>Marketing Designer</td>
					                    <td>San Francisco</td>
					                    <td>47</td>
					                    <td>2009/12/09</td>
					                    <td>$85,675</td>
					                </tr>
					                <tr>
					                    <td>Howard Hatfield</td>
					                    <td>Office Manager</td>
					                    <td>San Francisco</td>
					                    <td>51</td>
					                    <td>2008/12/16</td>
					                    <td>$164,500</td>
					                </tr>
					                <tr>
					                    <td>Hope Fuentes</td>
					                    <td>Secretary</td>
					                    <td>San Francisco</td>
					                    <td>41</td>
					                    <td>2010/02/12</td>
					                    <td>$109,850</td>
					                </tr>
					                <tr>
					                    <td>Vivian Harrell</td>
					                    <td>Financial Controller</td>
					                    <td>San Francisco</td>
					                    <td>62</td>
					                    <td>2009/02/14</td>
					                    <td>$452,500</td>
					                </tr>
					                <tr>
					                    <td>Timothy Mooney</td>
					                    <td>Office Manager</td>
					                    <td>London</td>
					                    <td>37</td>
					                    <td>2008/12/11</td>
					                    <td>$136,200</td>
					                </tr>
					                <tr>
					                    <td>Jackson Bradshaw</td>
					                    <td>Director</td>
					                    <td>New York</td>
					                    <td>65</td>
					                    <td>2008/09/26</td>
					                    <td>$645,750</td>
					                </tr>
					                <tr>
					                    <td>Olivia Liang</td>
					                    <td>Support Engineer</td>
					                    <td>Singapore</td>
					                    <td>64</td>
					                    <td>2011/02/03</td>
					                    <td>$234,500</td>
					                </tr>
					                <tr>
					                    <td>Bruno Nash</td>
					                    <td>Software Engineer</td>
					                    <td>London</td>
					                    <td>38</td>
					                    <td>2011/05/03</td>
					                    <td>$163,500</td>
					                </tr>
					                <tr>
					                    <td>Sakura Yamamoto</td>
					                    <td>Support Engineer</td>
					                    <td>Tokyo</td>
					                    <td>37</td>
					                    <td>2009/08/19</td>
					                    <td>$139,575</td>
					                </tr>
					                <tr>
					                    <td>Thor Walton</td>
					                    <td>Developer</td>
					                    <td>New York</td>
					                    <td>61</td>
					                    <td>2013/08/11</td>
					                    <td>$98,540</td>
					                </tr>
					                <tr>
					                    <td>Finn Camacho</td>
					                    <td>Support Engineer</td>
					                    <td>San Francisco</td>
					                    <td>47</td>
					                    <td>2009/07/07</td>
					                    <td>$87,500</td>
					                </tr>
					                <tr>
					                    <td>Serge Baldwin</td>
					                    <td>Data Coordinator</td>
					                    <td>Singapore</td>
					                    <td>64</td>
					                    <td>2012/04/09</td>
					                    <td>$138,575</td>
					                </tr>
					                <tr>
					                    <td>Zenaida Frank</td>
					                    <td>Software Engineer</td>
					                    <td>New York</td>
					                    <td>63</td>
					                    <td>2010/01/04</td>
					                    <td>$125,250</td>
					                </tr>
					                <tr>
					                    <td>Zorita Serrano</td>
					                    <td>Software Engineer</td>
					                    <td>San Francisco</td>
					                    <td>56</td>
					                    <td>2012/06/01</td>
					                    <td>$115,000</td>
					                </tr>
					                <tr>
					                    <td>Jennifer Acosta</td>
					                    <td>Junior Javascript Developer</td>
					                    <td>Edinburgh</td>
					                    <td>43</td>
					                    <td>2013/02/01</td>
					                    <td>$75,650</td>
					                </tr>
					                <tr>
					                    <td>Cara Stevens</td>
					                    <td>Sales Assistant</td>
					                    <td>New York</td>
					                    <td>46</td>
					                    <td>2011/12/06</td>
					                    <td>$145,600</td>
					                </tr>
					                <tr>
					                    <td>Hermione Butler</td>
					                    <td>Regional Director</td>
					                    <td>London</td>
					                    <td>47</td>
					                    <td>2011/03/21</td>
					                    <td>$356,250</td>
					                </tr>
					                <tr>
					                    <td>Lael Greer</td>
					                    <td>Systems Administrator</td>
					                    <td>London</td>
					                    <td>21</td>
					                    <td>2009/02/27</td>
					                    <td>$103,500</td>
					                </tr>
					                <tr>
					                    <td>Jonas Alexander</td>
					                    <td>Developer</td>
					                    <td>San Francisco</td>
					                    <td>30</td>
					                    <td>2010/07/14</td>
					                    <td>$86,500</td>
					                </tr>
					                <tr>
					                    <td>Shad Decker</td>
					                    <td>Regional Director</td>
					                    <td>Edinburgh</td>
					                    <td>51</td>
					                    <td>2008/11/13</td>
					                    <td>$183,000</td>
					                </tr>
					                <tr>
					                    <td>Michael Bruce</td>
					                    <td>Javascript Developer</td>
					                    <td>Singapore</td>
					                    <td>29</td>
					                    <td>2011/06/27</td>
					                    <td>$183,000</td>
					                </tr>
					                <tr>
					                    <td>Donna Snider</td>
					                    <td>Customer Support</td>
					                    <td>New York</td>
					                    <td>27</td>
					                    <td>2011/01/25</td>
					                    <td>$112,000</td>
					                </tr>
					            </tbody>
					        </table>
					    </div>
					</div>
					<!--===================================================-->
					<!-- End Striped Table -->
					
