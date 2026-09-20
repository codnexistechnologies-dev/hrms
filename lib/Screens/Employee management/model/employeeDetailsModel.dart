class EmployeeDetailsModel {
  List<EmpType>? data;

  EmployeeDetailsModel({this.data});

  EmployeeDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EmpType>[];
      json['data'].forEach((v) {
        data!.add(EmpType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmpType {
  dynamic banKCODE;
  dynamic bankacno;
  dynamic bloodgrp;
  dynamic comPCODE;
  dynamic loCNAME;
  dynamic longitude;
  dynamic latitude;
  dynamic cosTCODE;
  dynamic depTCODE;
  dynamic depTNAME;
  dynamic divICODE;
  dynamic dob;
  dynamic doj;
  dynamic doc;
  dynamic dol;
  dynamic dsGCODE;
  dynamic dsGNAME;
  dynamic emPCODE;
  dynamic esino;
  dynamic fatHNAME;
  dynamic fname;
  dynamic grDCODE;
  dynamic lname;
  dynamic lnotice;
  dynamic loCCODE;
  dynamic lreason;
  dynamic ltype;
  dynamic maddR1;
  dynamic maddR2;
  dynamic maddR3;
  dynamic mcity;
  dynamic mcountry;
  dynamic mname;
  dynamic mobileno;
  dynamic mphone;
  dynamic mpin;
  dynamic mstate;
  dynamic mstatus;
  dynamic occuPCODE;
  dynamic paddR1;
  dynamic paddR2;
  dynamic paddR3;
  dynamic pagerno;
  dynamic panno;
  dynamic passportno;
  dynamic pcity;
  dynamic pcountry;
  dynamic pfno;
  dynamic pphone;
  dynamic ppin;
  dynamic pstate;
  dynamic ptaXYN;
  dynamic regNCODE;
  dynamic secTCODE;
  dynamic seTDATE;
  dynamic sex;
  dynamic title;
  dynamic typECODE;
  dynamic phoneno;
  dynamic emailPWD;
  dynamic proCCODE;
  dynamic mngRCODE;
  dynamic fatHHUSB;
  dynamic mPhoneNo;
  dynamic pPhoneNo;
  dynamic birthplace;
  dynamic nationality;
  dynamic domicile;
  dynamic dom;
  dynamic dov;
  dynamic metro;
  dynamic jobprofile;
  dynamic emPPICT;
  dynamic joBCODE;
  dynamic emPCLASS;
  dynamic fulLPART;
  dynamic conTTYPE;
  dynamic busSTITLE;
  dynamic busSUNIT;
  dynamic serVDATE;
  dynamic lsAPLAN;
  dynamic company;
  dynamic jobrank;
  dynamic hRMNGR;
  dynamic uniTCODE;
  dynamic spouse;
  dynamic undeRLOC;
  dynamic state;
  dynamic paYCODE;
  dynamic currbankac;
  dynamic ifsc;
  dynamic cardno;
  dynamic taxregimEDATE;
  dynamic taxregimEYN;
  dynamic suBCOMPCODE;
  dynamic bheaDYN;
  dynamic cfOYN;
  dynamic mDYN;
  dynamic coOYN;
  dynamic cbOYN;
  dynamic financEYN;
  dynamic asSFINANCEYN;
  dynamic inneRDEPT;
  dynamic confirmationYN;
  dynamic fuelNDriveYN;
  dynamic emPTITLE;
  dynamic emPNAME;
  dynamic namECODE;
  dynamic comPNAME;
  dynamic comPADDR;
  dynamic comPCITY;
  dynamic comPSTATE;
  dynamic comPPIN;
  dynamic comPPFNO;
  dynamic uanno;
  dynamic voteRID;
  dynamic adhaRNO;
  dynamic banKNAME;
  dynamic statENAME;
  dynamic emailid;
  dynamic emailpwd;
  dynamic mphoneno;
  dynamic pphoneno;
  dynamic religion;
  dynamic cast;
  dynamic dlno;
  dynamic dladdress;
  dynamic fathhusb;
  dynamic fathhusbname;
  dynamic fathhusbocupation;
  dynamic band;
  dynamic pemailid;
  dynamic bankbrcode;
  dynamic confirmatioNYN;
  dynamic fuelndrivEYN;
  dynamic mailingaddress;
  dynamic permanentaddress;

  EmpType(
      {this.banKCODE,
      this.bankacno,
      this.bloodgrp,
      this.comPCODE,
      this.loCNAME,
      this.longitude,
      this.latitude,
      this.cosTCODE,
      this.depTCODE,
      this.depTNAME,
      this.divICODE,
      this.dob,
      this.doj,
      this.doc,
      this.dol,
      this.dsGCODE,
      this.dsGNAME,
      this.emPCODE,
      this.esino,
      this.fatHNAME,
      this.fname,
      this.grDCODE,
      this.lname,
      this.lnotice,
      this.loCCODE,
      this.lreason,
      this.ltype,
      this.maddR1,
      this.maddR2,
      this.maddR3,
      this.mcity,
      this.mcountry,
      this.mname,
      this.mobileno,
      this.mphone,
      this.mpin,
      this.mstate,
      this.mstatus,
      this.occuPCODE,
      this.paddR1,
      this.paddR2,
      this.paddR3,
      this.pagerno,
      this.panno,
      this.passportno,
      this.pcity,
      this.pcountry,
      this.pfno,
      this.pphone,
      this.ppin,
      this.pstate,
      this.ptaXYN,
      this.regNCODE,
      this.secTCODE,
      this.seTDATE,
      this.sex,
      this.title,
      this.typECODE,
      this.phoneno,
      this.emailPWD,
      this.proCCODE,
      this.mngRCODE,
      this.fatHHUSB,
      this.mPhoneNo,
      this.pPhoneNo,
      this.birthplace,
      this.nationality,
      this.domicile,
      this.dom,
      this.dov,
      this.metro,
      this.jobprofile,
      this.emPPICT,
      this.joBCODE,
      this.emPCLASS,
      this.fulLPART,
      this.conTTYPE,
      this.busSTITLE,
      this.busSUNIT,
      this.serVDATE,
      this.lsAPLAN,
      this.company,
      this.jobrank,
      this.hRMNGR,
      this.uniTCODE,
      this.spouse,
      this.undeRLOC,
      this.state,
      this.paYCODE,
      this.currbankac,
      this.ifsc,
      this.cardno,
      this.taxregimEDATE,
      this.taxregimEYN,
      this.suBCOMPCODE,
      this.bheaDYN,
      this.cfOYN,
      this.mDYN,
      this.coOYN,
      this.cbOYN,
      this.financEYN,
      this.asSFINANCEYN,
      this.inneRDEPT,
      this.confirmationYN,
      this.fuelNDriveYN,
      this.emPTITLE,
      this.emPNAME,
      this.namECODE,
      this.comPNAME,
      this.comPADDR,
      this.comPCITY,
      this.comPSTATE,
      this.comPPIN,
      this.comPPFNO,
      this.uanno,
      this.voteRID,
      this.adhaRNO,
      this.banKNAME,
      this.statENAME,
      this.emailid,
      this.emailpwd,
      this.mphoneno,
      this.pphoneno,
      this.religion,
      this.cast,
      this.dlno,
      this.dladdress,
      this.fathhusb,
      this.fathhusbname,
      this.fathhusbocupation,
      this.band,
      this.pemailid,
      this.bankbrcode,
      this.confirmatioNYN,
      this.fuelndrivEYN,
      this.mailingaddress,
      this.permanentaddress});

  EmpType.fromJson(Map<String, dynamic> json) {
    banKCODE = json['banK_CODE'];
    bankacno = json['bankacno'];
    bloodgrp = json['bloodgrp'];
    comPCODE = json['comP_CODE'];
    loCNAME = json['loC_NAME'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    cosTCODE = json['cosT_CODE'];
    depTCODE = json['depT_CODE'];
    depTNAME = json['depT_NAME'];
    divICODE = json['divI_CODE'];
    dob = json['dob'];
    doj = json['doj'];
    doc = json['doc'];
    dol = json['dol'];
    dsGCODE = json['dsG_CODE'];
    dsGNAME = json['dsG_NAME'];
    emPCODE = json['emP_CODE'];
    esino = json['esino'];
    fatHNAME = json['fatH_NAME'];
    fname = json['fname'];
    grDCODE = json['grD_CODE'];
    lname = json['lname'];
    lnotice = json['lnotice'];
    loCCODE = json['loC_CODE'];
    lreason = json['lreason'];
    ltype = json['ltype'];
    maddR1 = json['maddR1'];
    maddR2 = json['maddR2'];
    maddR3 = json['maddR3'];
    mcity = json['mcity'];
    mcountry = json['mcountry'];
    mname = json['mname'];
    mobileno = json['mobileno'];
    mphone = json['mphone'];
    mpin = json['mpin'];
    mstate = json['mstate'];
    mstatus = json['mstatus'];
    occuPCODE = json['occuP_CODE'];
    paddR1 = json['paddR1'];
    paddR2 = json['paddR2'];
    paddR3 = json['paddR3'];
    pagerno = json['pagerno'];
    panno = json['panno'];
    passportno = json['passportno'];
    pcity = json['pcity'];
    pcountry = json['pcountry'];
    pfno = json['pfno'];
    pphone = json['pphone'];
    ppin = json['ppin'];
    pstate = json['pstate'];
    ptaXYN = json['ptaX_YN'];
    regNCODE = json['regN_CODE'];
    secTCODE = json['secT_CODE'];
    seTDATE = json['seT_DATE'];
    sex = json['sex'];
    title = json['title'];
    typECODE = json['typE_CODE'];
    phoneno = json['phoneno'];
    emailPWD = json['emailPWD'];
    proCCODE = json['proC_CODE'];
    mngRCODE = json['mngR_CODE'];
    fatHHUSB = json['fatH_HUSB'];
    mPhoneNo = json['mPhoneNo'];
    pPhoneNo = json['pPhoneNo'];
    birthplace = json['birthplace'];
    nationality = json['nationality'];
    domicile = json['domicile'];
    dom = json['dom'];
    dov = json['dov'];
    metro = json['metro'];
    jobprofile = json['jobprofile'];
    emPPICT = json['emP_PICT'];
    joBCODE = json['joB_CODE'];
    emPCLASS = json['emP_CLASS'];
    fulLPART = json['fulL_PART'];
    conTTYPE = json['conT_TYPE'];
    busSTITLE = json['busS_TITLE'];
    busSUNIT = json['busS_UNIT'];
    serVDATE = json['serV_DATE'];
    lsAPLAN = json['lsA_PLAN'];
    company = json['company'];
    jobrank = json['jobrank'];
    hRMNGR = json['hR_MNGR'];
    uniTCODE = json['uniT_CODE'];
    spouse = json['spouse'];
    undeRLOC = json['undeR_LOC'];
    state = json['state'];
    paYCODE = json['paY_CODE'];
    currbankac = json['currbankac'];
    ifsc = json['ifsc'];
    cardno = json['cardno'];
    taxregimEDATE = json['taxregimE_DATE'];
    taxregimEYN = json['taxregimE_YN'];
    suBCOMPCODE = json['suB_COMP_CODE'];
    bheaDYN = json['bheaD_YN'];
    cfOYN = json['cfO_YN'];
    mDYN = json['mD_YN'];
    coOYN = json['coO_YN'];
    cbOYN = json['cbO_YN'];
    financEYN = json['financE_YN'];
    asSFINANCEYN = json['asS_FINANCE_YN'];
    inneRDEPT = json['inneR_DEPT'];
    confirmationYN = json['confirmation_YN'];
    fuelNDriveYN = json['fuelNDrive_YN'];
    emPTITLE = json['emP_TITLE'];
    emPNAME = json['emP_NAME'];
    namECODE = json['namE_CODE'];

    comPNAME = json['comP_NAME'];
    comPADDR = json['comP_ADDR'];
    comPCITY = json['comP_CITY'];
    comPSTATE = json['comP_STATE'];
    comPPIN = json['comP_PIN'];
    comPPFNO = json['comP_PFNO'];
    uanno = json['uanno'];
    voteRID = json['voteR_ID'];
    adhaRNO = json['adhaR_NO'];
    banKNAME = json['banK_NAME'];
    statENAME = json['statE_NAME'];
    emailid = json['emailid'];
    emailpwd = json['emailpwd'];
    mphoneno = json['mphoneno'];
    pphoneno = json['pphoneno'];
    religion = json['religion'];
    cast = json['cast'];
    dlno = json['dlno'];
    dladdress = json['dladdress'];
    fathhusb = json['fathhusb'];
    fathhusbname = json['fathhusbname'];
    fathhusbocupation = json['fathhusbocupation'];
    band = json['band'];
    pemailid = json['pemailid'];
    bankbrcode = json['bankbrcode'];
    confirmatioNYN = json['confirmatioN_YN'];
    fuelndrivEYN = json['fuelndrivE_YN'];
    mailingaddress = json['mailingaddress'];
    permanentaddress = json['permanentaddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banK_CODE'] = banKCODE;
    data['bankacno'] = bankacno;
    data['bloodgrp'] = bloodgrp;
    data['comP_CODE'] = comPCODE;
    data['loC_NAME'] = loCNAME;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['cosT_CODE'] = cosTCODE;
    data['depT_CODE'] = depTCODE;
    data['depT_NAME'] = depTNAME;
    data['divI_CODE'] = divICODE;
    data['dob'] = dob;
    data['doj'] = doj;
    data['doc'] = doc;
    data['dol'] = dol;
    data['dsG_CODE'] = dsGCODE;
    data['dsG_NAME'] = dsGNAME;
    data['emP_CODE'] = emPCODE;
    data['esino'] = esino;
    data['fatH_NAME'] = fatHNAME;
    data['fname'] = fname;
    data['grD_CODE'] = grDCODE;
    data['lname'] = lname;
    data['lnotice'] = lnotice;
    data['loC_CODE'] = loCCODE;
    data['lreason'] = lreason;
    data['ltype'] = ltype;
    data['maddR1'] = maddR1;
    data['maddR2'] = maddR2;
    data['maddR3'] = maddR3;
    data['mcity'] = mcity;
    data['mcountry'] = mcountry;
    data['mname'] = mname;
    data['mobileno'] = mobileno;
    data['mphone'] = mphone;
    data['mpin'] = mpin;
    data['mstate'] = mstate;
    data['mstatus'] = mstatus;
    data['occuP_CODE'] = occuPCODE;
    data['paddR1'] = paddR1;
    data['paddR2'] = paddR2;
    data['paddR3'] = paddR3;
    data['pagerno'] = pagerno;
    data['panno'] = panno;
    data['passportno'] = passportno;
    data['pcity'] = pcity;
    data['pcountry'] = pcountry;
    data['pfno'] = pfno;
    data['pphone'] = pphone;
    data['ppin'] = ppin;
    data['pstate'] = pstate;
    data['ptaX_YN'] = ptaXYN;
    data['regN_CODE'] = regNCODE;
    data['secT_CODE'] = secTCODE;
    data['seT_DATE'] = seTDATE;
    data['sex'] = sex;
    data['title'] = title;
    data['typE_CODE'] = typECODE;
    data['phoneno'] = phoneno;
    data['emailPWD'] = emailPWD;
    data['proC_CODE'] = proCCODE;
    data['mngR_CODE'] = mngRCODE;
    data['fatH_HUSB'] = fatHHUSB;
    data['mPhoneNo'] = mPhoneNo;
    data['pPhoneNo'] = pPhoneNo;
    data['birthplace'] = birthplace;
    data['nationality'] = nationality;
    data['domicile'] = domicile;
    data['dom'] = dom;
    data['dov'] = dov;
    data['metro'] = metro;
    data['jobprofile'] = jobprofile;
    data['emP_PICT'] = emPPICT;
    data['joB_CODE'] = joBCODE;
    data['emP_CLASS'] = emPCLASS;
    data['fulL_PART'] = fulLPART;
    data['conT_TYPE'] = conTTYPE;
    data['busS_TITLE'] = busSTITLE;
    data['busS_UNIT'] = busSUNIT;
    data['serV_DATE'] = serVDATE;
    data['lsA_PLAN'] = lsAPLAN;
    data['company'] = company;
    data['jobrank'] = jobrank;
    data['hR_MNGR'] = hRMNGR;
    data['uniT_CODE'] = uniTCODE;
    data['spouse'] = spouse;
    data['undeR_LOC'] = undeRLOC;
    data['state'] = state;
    data['paY_CODE'] = paYCODE;
    data['currbankac'] = currbankac;
    data['ifsc'] = ifsc;
    data['cardno'] = cardno;
    data['taxregimE_DATE'] = taxregimEDATE;
    data['taxregimE_YN'] = taxregimEYN;
    data['suB_COMP_CODE'] = suBCOMPCODE;
    data['bheaD_YN'] = bheaDYN;
    data['cfO_YN'] = cfOYN;
    data['mD_YN'] = mDYN;
    data['coO_YN'] = coOYN;
    data['cbO_YN'] = cbOYN;
    data['financE_YN'] = financEYN;
    data['asS_FINANCE_YN'] = asSFINANCEYN;
    data['inneR_DEPT'] = inneRDEPT;
    data['confirmation_YN'] = confirmationYN;
    data['fuelNDrive_YN'] = fuelNDriveYN;
    data['emP_TITLE'] = emPTITLE;
    data['emP_NAME'] = emPNAME;
    data['namE_CODE'] = namECODE;
    data['comP_NAME'] = comPNAME;
    data['comP_ADDR'] = comPADDR;
    data['comP_CITY'] = comPCITY;
    data['comP_STATE'] = comPSTATE;
    data['comP_PIN'] = comPPIN;
    data['comP_PFNO'] = comPPFNO;
    data['uanno'] = uanno;
    data['voteR_ID'] = voteRID;
    data['adhaR_NO'] = adhaRNO;
    data['banK_NAME'] = banKNAME;
    data['statE_NAME'] = statENAME;
    data['emailid'] = emailid;
    data['emailpwd'] = emailpwd;
    data['mphoneno'] = mphoneno;
    data['pphoneno'] = pphoneno;
    data['religion'] = religion;
    data['cast'] = cast;
    data['dlno'] = dlno;
    data['dladdress'] = dladdress;
    data['fathhusb'] = fathhusb;
    data['fathhusbname'] = fathhusbname;
    data['fathhusbocupation'] = fathhusbocupation;
    data['band'] = band;
    data['pemailid'] = pemailid;
    data['bankbrcode'] = bankbrcode;
    data['confirmatioN_YN'] = confirmatioNYN;
    data['fuelndrivE_YN'] = fuelndrivEYN;
    data['mailingaddress'] = mailingaddress;
    data['permanentaddress'] = permanentaddress;
    return data;
  }
}
