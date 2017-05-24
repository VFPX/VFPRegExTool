Close Data
Try
	Use myregexp Shared
	If Type('myregexp.Global') = 'U'
		Close Data
		Alter Table myregexp Add Column Global l
		Alter Table myregexp Add Column ignorecase l
	Endif

Catch
	Try

		TEXT TO DBF NOSHOW

<?xml version = "1.0" encoding="Windows-1252" standalone="yes"?>
<VFPData>
	<xsd:schema id="VFPData" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
		<xsd:element name="VFPData" msdata:IsDataSet="true">
			<xsd:complexType>
				<xsd:choice maxOccurs="unbounded">
					<xsd:element name="myregexp" minOccurs="0" maxOccurs="unbounded">
						<xsd:complexType>
							<xsd:sequence>
								<xsd:element name="name">
									<xsd:simpleType>
										<xsd:restriction base="xsd:string">
											<xsd:maxLength value="150"/>
										</xsd:restriction>
									</xsd:simpleType>
								</xsd:element>
								<xsd:element name="regexp">
									<xsd:simpleType>
										<xsd:restriction base="xsd:string">
											<xsd:maxLength value="2147483647"/>
										</xsd:restriction>
									</xsd:simpleType>
								</xsd:element>
								<xsd:element name="evaltext">
									<xsd:simpleType>
										<xsd:restriction base="xsd:string">
											<xsd:maxLength value="2147483647"/>
										</xsd:restriction>
									</xsd:simpleType>
								</xsd:element>
								<xsd:element name="help">
									<xsd:simpleType>
										<xsd:restriction base="xsd:string">
											<xsd:maxLength value="2147483647"/>
										</xsd:restriction>
									</xsd:simpleType>
								</xsd:element>
								<xsd:element name="global" type="xsd:boolean"/>
								<xsd:element name="ignorecase" type="xsd:boolean"/>
							</xsd:sequence>
						</xsd:complexType>
					</xsd:element>
				</xsd:choice>
				<xsd:anyAttribute namespace="http://www.w3.org/XML/1998/namespace" processContents="lax"/>
			</xsd:complexType>
		</xsd:element>
	</xsd:schema>
	<myregexp>
		<name>ms sample 1</name>
		<regexp>(\d{3})-(\d{3}-\d{4})</regexp>
		<evaltext>212-555-6666 906-932-1111 415-222-3333 425-888-9999</evaltext>
		<help/>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>ms sample 2</name>
		<regexp>\b(\w+\s*)+\.</regexp>
		<evaltext>This is a sentence. This is another sentence.</evaltext>
		<help>: https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.group.captures(v=vs.110).aspx</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>capturing groups sample</name>
		<regexp>\d+-((\d{3})-(\d{4}))</regexp>
		<evaltext>212-555-6666 906-932-1111 415-222-3333 425-888-9999</evaltext>
		<help>http://www.regular-expressions.info/tutorial.html</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name/>
		<regexp/>
		<evaltext/>
		<help/>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>ms "SubMatches Collection" example</name>
		<regexp>(\w+)@(\w+)\.(\w+)</regexp>
		<evaltext>Please send mail to someone@example.com. Thanks!</evaltext>
		<help>https://msdn.microsoft.com/en-us/library/y27d2s18%28v=vs.84%29.aspx?f=255&amp;MSPPError=-2147217396</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>ms sample 3</name>
		<regexp>(?:\b(?:\w+)\W*)+\.</regexp>
		<evaltext>This is a short sentence.</evaltext>
		<help>http://tinyurl.com/janfy7x</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>Identify Special Characters</name>
		<regexp>(?![a-zA-Z0-9])[!-~]</regexp>
		<evaltext>This is a #$short sentence.}]]{</evaltext>
		<help>http://www.rexegg.com/regex-interesting-character-classes.html</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>consecurive duplicated words</name>
		<regexp>(\w+)\s(\1)\W</regexp>
		<evaltext>He said that that was the the correct answer.</evaltext>
		<help/>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>US PHONE NUMBERS</name>
		<regexp>(\d{3})-(\d{3}-\d{4})</regexp>
		<evaltext>212-555-6666 906-932-1111 415-222-3333 425-888-9999</evaltext>
		<help/>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
	<myregexp>
		<name>look up bad program calls</name>
		<regexp>do myprogram with (?!\d{3},\.t\.)(\w+),([^ ]*)</regexp>
		<evaltext>do myprogram with 122,.t. &amp;&amp; THIS IS OK ( 3 NUMBERS,.T.) , don't match
do myprogram with wrongparameter,.t. &amp;&amp; bad call match no number
do myprogram with 1234,.t. &amp;&amp; bad call match no 3 digit number
do myprogram with 122,.f. &amp;&amp; second parameter must be .t.</evaltext>
		<help>using negative lookahead;
http://www.regular-expressions.info/lookaround.html</help>
		<global>false</global>
		<ignorecase>false</ignorecase>
	</myregexp>
</VFPData>

		ENDTEXT

		Xmltocursor(M.DBF,'TEMP')
		Copy To JUSTPATH(SYS(16,0))+'\myregexp.Dbf'
		Close Databases
		Use myregexp Shared

	Catch
	Endtry

Endtry

If !Used('myregexp')
	Messagebox(' Unable to create regexp table "'+Sys(5)+Curdir()+'myregexp.dbf"' ,0)
	Return .F.
Endif

Close Databases
