******************************************************
* Regular Expression Tool
* Marco Plaza, 2016
******************************************************
#Define crlf Chr(13)+Chr(10)

If !checkdbf()
	Return
Endif

Do Form vfpRegexTool Name oForm

With oForm

	Set DataSession To oForm.DataSessionId
	Set Exclusive Off
	Set Deleted On

	.AddProperty('oRegex', Createobject('vbscript.regexp') )
	.AddProperty('color(4)')

	.AddProperty('grupo(1)')

	.AddProperty('ngrupos')

	.Color(1) = Rgb(128,0,255)
	.Color(2) = Rgb(106,79,217)
	.Color(3) = Rgb(0,160,200)
	.Color(4) = Rgb(250,200,0)

	.oregex.multiline = .t.

	With .textToEvaluate As richtext.richtextctrl.1
		.Font.Name ='Consolas'
		.Font.bold = .F.
		.Font.Size = 10
	Endwith

	.AddProperty( 'undo','')

	.result.FontName = 'Consolas'
	.result.FontSize = 12

	.regexp.FontSize = 12
	.regexp.FontName = 'Consolas'

Endwith

Read Events


*----------------------------------------
Procedure regexpTest
*----------------------------------------

With oForm

	IF !.evalEnabled.value
		RETURN
	ENDIF

	.result.Value = ''
	.matchesLbl.BackStyle = 0
	.regexpLbl.BackStyle = 0

	With .textToEvaluate
		.SelStart = 0
		.SelLength = Len(.Text)
		.selBold = .F.
		.selColor = 0
		.selUnderline = 0
	Endwith

	If Empty(.regexp.Value)
		Return
	Endif

	.LockScreen = .T.

	Try

		.oregex.Global = .evalGlobal.Value
		.oregex.ignorecase = .evalIgnorecase.Value
		.oregex.Pattern = Alltrim(.regexp.Value)
		.oregex.multiline = .evalMultiline.value
		

		processGroups()


		match = .oregex.test(Alltrim(.textToEvaluate.Text))

		#Define verde Rgb(150,250,100)
		#Define rojo  Rgb(250,60,60)

		.regexpLbl.BackColor = verde
		.regexpLbl.BackStyle = 1
		.matchesLbl.BackStyle = 1

		If !m.match

			.matchesLbl.BackColor = rojo

		Else

			.matchesLbl.BackColor = verde


			oResult = .oregex.execute(.textToEvaluate.Text)


			If oResult.Count > 0

				For Each Item In oResult

					.result.Value = .result.Value+'MATCH: '+Item.Value+crlf

					With .textToEvaluate As richtext.richtextctrl.1
						.SelStart = Item.firstIndex
						.SelLength = Item.Length
						.selBold  = .T.
						.selColor = 255
					Endwith

					Index = 1
					remainStr = Item.Value
					offset = Item.firstIndex

					For Each subMatch In Item.submatches

						.result.Value = .result.Value+'subMatch '+Transform(m.index,'@l 99')+' ('+.grupo(M.index)+'): '+subMatch +crlf

						If Len(m.subMatch) = 0
							Index = m.index+1
							Loop
						Endif

						thisoffset = At(m.subMatch,m.remainStr)

						With .textToEvaluate As richtext.richtextctrl.1

							.SelStart  = m.offset + m.thisoffset - 1
							.SelLength = Len(subMatch)

							If oForm.grupo(M.index) = 'Group'
								.selUnderline = .T.
							Endif

							.selColor = oForm.Color( 1+Index%4 )

						Endwith

						Index = m.index+1

						ssubm = Iif( Index < oForm.ngrupos And oForm.grupo(M.index) = 'Group' Or  oForm.grupo(M.index-1) # 'Group',Len(subMatch),0)
						offset = m.offset+m.thisoffset-1  + m.ssubm
						remainStr = Substr( m.remainStr, m.thisoffset + m.ssubm )


					Endfor

				Endfor
			Endif

		Endif


	Catch To oerr

*		Messagebox(Transform(oerr.Lineno)+':'+oerr.Message,0)
		.regexpLbl.BackColor = rojo
		.regexpLbl.BackStyle = 1
		.matchesLbl.BackStyle = 0

	Endtry

	.LockScreen = .F.

Endwith



*----------------------------------
Function processGroups
*----------------------------------

With oForm

	remstr = Strtran(.oregex.Pattern,'\(','')
	remstr = Strtran(.oregex.Pattern,'\)','')

	.ngrupos = Occurs('(', m.remstr )


	If .ngrupos > 0

		Dimension .grupo( .ngrupos )
		.grupo(1) = 'Group'
		PD = 1
		Pi = 2
		NG = 2

		If .ngrupos > 1

			For x = 1 To .ngrupos*2

				SIGUE = Iif( At( '(', M.remstr, M.PI ) < At( ')', M.remstr, M.PD ), '(',')')

				If SIGUE = '('
					.grupo(M.NG) = Iif( m.PI-m.PD > 0 , 'subGroup','Group' )
					If m.NG = .ngrupos
						Exit
					Endif
					m.NG = M.NG+1
					Pi = m.PI+1
				Else
					PD = m.PD+1
				Endif

			Endfor

		Endif

	Endif

Endwith

*----------------------------------------
Function Replace
*----------------------------------------

processGroups()

oResult = oForm.oregex.execute(oForm.textToEvaluate.Text)

Do Case
Case oResult.Count  = 0
	Messagebox('No match!',64)
	Return
Case oForm.replaceGroup.Value > oResult.Item(0).submatches.Count
	Messagebox('Replace Group number outside of scope',32)
	Return
Endcase

Store oForm.textToEvaluate.Text To oForm.Undo

rGroup = oForm.replaceGroup.Value
rExp   = oForm.replaceExpression.Value

rExp = Strtran( m.rExp,'_0','item.value')

For x = 1 To 19
	rExp = Strtran( m.rExp,'_'+Transform(m.x),'item.submatches('+Transform(m.x-1)+')' )
Endfor

offset = 1
tresult = ''


For Each Item In oResult


	With oForm.textToEvaluate As richtext.richtextctrl.1

		tresult = m.tresult+Substr(.Text,m.offset,Item.firstIndex-m.offset+1)

		Try

			If oForm.replaceGroup.Value = 0

				tresult = m.tresult + Evaluate( m.rExp )
				rok= .T.

			Else

				replaceSubMatch()
				rok = .T.

			Endif

		Catch To oerr
			Messagebox( oerr.Message , 0 )
			rok = .F.
		Endtry

		If !rok
			Exit
		Endif

		offset = Item.firstIndex + Item.Length + 1

	Endwith

Endfor

tresult = m.tresult + Substr( oForm.textToEvaluate.Text , m.offset )

oForm.textToEvaluate.Text = m.tresult

regexpTest()


*--------------------------------------------
Function replaceSubMatch
*--------------------------------------------

Local Index
Local remainStr
Local offset

offset = 0

Index = 1
remainStr = Item.Value

For Each subMatch In Item.submatches

	thisoffset = Evl(At(m.subMatch,m.remainStr),1)

	If Index = oForm.replaceGroup.Value
		tresult = m.tresult + Left(Item.Value, M.offset + m.thisoffset -1 )
		tresult = m.tresult + Evaluate( m.rExp )
		tresult = M.tresult + Substr( Item.Value , M.offset + m.thisoffset + Len(subMatch)  )
		Exit
	Endif

	Index = m.index+1

	ssubm = Iif( Index <= oForm.ngrupos And oForm.grupo(M.index) = 'Group' Or  oForm.grupo(M.index-1) # 'Group',Len(subMatch),0)

	offset = m.offset+m.thisoffset-1  + m.ssubm

	remainStr = Substr( m.remainStr, m.thisoffset + m.ssubm )

Endfor
