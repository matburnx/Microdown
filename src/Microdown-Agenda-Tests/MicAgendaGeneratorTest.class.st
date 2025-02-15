"
This class contains tests but all the test are not correct beacaus we need to have a file in a repertory with the templates because if we don't have them we can't generate the calendar.
"
Class {
	#name : 'MicAgendaGeneratorTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'builder',
		'parser',
		'writer',
		'fileSystem',
		'newLine'
	],
	#pools : [
		'MicMicrodownSharedPool'
	],
	#category : 'Microdown-Agenda-Tests',
	#package : 'Microdown-Agenda-Tests'
}

{ #category : 'building suites' }
MicAgendaGeneratorTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  forSelector: #writer addOptions: { MicAgendaGenerator };
		  forSelector: #fileSystem addOptions: { FileSystem };
		  forSelector: #newLine addOptions: { String crlf . String cr . String lf };
		  yourself
]

{ #category : 'exemple' }
MicAgendaGeneratorTest >> agendaExempleMultiplesTalks [

 ^ '<!agenda|title=A cool agenda

<!day|start=3 mars 2023

<!segment|start=10h30

<!talk|subject=First talk&length=30m&author=Delporte Gaylord&room=Building B
!>
<!break|subject=Break&length=2h&room=Building A
!>
<!talk|subject=Second talk&length=1h&author=Not me&room=Building C
!>

!>

!>

<!day|start=4 mars 2023

<!segment|start=10h00

<!talk|subject=Ninth talk&length=30m&author=Delporte Gaylord&room=Building G
!>
<!break|subject=Break&length=2h&room=Building F
!>
<!talk|subject=Second talk&length=1h&author=Not Someone&room=Building Q
!>

!>

!>

!>'
	
]

{ #category : 'exemple' }
MicAgendaGeneratorTest >> agendaExempleOneTalk [

 ^ '<!agenda|title=A cool agenda

<!day|start=3 mars 2023

<!segment|start=10h30

<!talk|subject=First talk&length=30m&author=Delporte Gaylord&room=Building B
!>
!>

!>

!>'
	
]

{ #category : 'exemple' }
MicAgendaGeneratorTest >> agendaExempleWithRealInfo [

 ^ '<!agenda|title=A cool agenda

<!day|start=22 aout 2022

<!segment|start=9h30

<!break|subject=Welcome&length=30m&room=Amphi
!>

<!talk|subject=PharoJS&length=45m&author=N. BOURAQADI and D. MASON&room=Amphi
!>

<!talk|subject=eXtreme Programming&length=45m&author=V. BLONDEAU and F. CANIPA&room=Amphi
!>

<!talk|subject=Grafoscopio&length=30m&author=O. LUNA&room=Amphi
!>

<!break|subject=Lunch&length=2h&room=Amphi
!>

<!talk|subject=Persistence in Pharo&length=45m&author=M. DENKER and N. HARTI&room=Amphi
!>

<!talk|subject=Pharo-IA&length=30m&author=S. MONTANO and O. ZAITSEV&room=Amphi
!>

<!talk|subject=Microdown&length=30m&author=S. DUCASSE and K. OSTERBYE&room=Amphi
!>

<!break|subject=Cofee Break&length=30m&room=Amphi
!>

<!talk|subject=Working with Remote Images&length=45m&author=A. GRANT&room=Amphi
!>

<!break|subject=Award Competition&length=2h&room=Amphi
!>

!>

!>

!>'
	
]

{ #category : 'accessing' }
MicAgendaGeneratorTest >> fileSystem: aFileSystem [
	fileSystem := aFileSystem memory.
]

{ #category : 'accessing' }
MicAgendaGeneratorTest >> newLine: aNewLine [
	(aNewLine = String cr) ifTrue:[ writer crAsNewLine ].
	(aNewLine = String lf) ifTrue:[ writer lfAsNewLine ].
	(aNewLine = String crlf) ifTrue:[ writer crlfAsNewLine ].
	newLine := aNewLine
]

{ #category : 'running' }
MicAgendaGeneratorTest >> setUp [

	super setUp.
	builder := MicMicrodownTextualBuilder new.
	parser := Microdown new.
]

{ #category : 'tests' }
MicAgendaGeneratorTest >> testAgendaAstIsCorrect [

	| fs file ast agenda day segment|

	fs := FileSystem memory.
	file := fs root / 'agenda.md'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self agendaExempleMultiplesTalks ].
	
	ast := parser parse: file contents.
	agenda := ast children first.
	day := agenda children first.
	segment := day children first.
	self assert: agenda class equals: MicAgendaBlock.
	self assert: day class equals: MicDayBlock.
	self assert: segment class equals: MicSegmentBlock.
	self assert: segment children size equals: 3.
	
]

{ #category : 'tests' }
MicAgendaGeneratorTest >> testConvertMicFileCorrectly [

	"Look at the class comment for more information about this test"

	"| fs file ast|
	fs := FileSystem memory.
	file := fs root / 'agenda.md'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self agendaExempleMultiplesTalks ].
	
	ast := parser parse: file contents.
	
	writer visit: ast.
	
	self assert: writer contents equals:
'3 mars 2023', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">10h30 - 11h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Delporte Gaylord</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">First talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building B</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">11h00 - 13h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name""></span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Break</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building A</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">13h00 - 14h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Not me</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Second talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building C</div>', newLine,
'										</div>', newLine,
'								</li>', newLine, newLine"
	
]

{ #category : 'tests' }
MicAgendaGeneratorTest >> testConvertMicFileCorrectlyWithMultiplesTalks [

	"Look at the class comment for more information about this test"

	"| fs file ast|

	fs := FileSystem memory.
	file := fs root / 'agenda.md'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self agendaExempleMultiplesTalks ].
	
	ast := parser parse: file contents.
	
	writer visit: ast.
	
	self assert: writer contents equals:
'3 mars 2023', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">10h30 - 11h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Delporte Gaylord</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">First talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building B</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">11h00 - 13h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name""></span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Break</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building A</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">13h00 - 14h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Not me</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Second talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building C</div>', newLine,
'										</div>', newLine,
'								</li>', newLine, newLine"
	
]

{ #category : 'tests' }
MicAgendaGeneratorTest >> testConvertMicFileCorrectlyWithOneTalk [

	"Look at the class comment for more information about this test"

	"| fs file ast|

	fs := FileSystem memory.
	file := fs root / 'agenda.md'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self agendaExempleOneTalk ].
	
	ast := parser parse: file contents.
	
	writer visit: ast.
	
	self assert: writer contents equals:
'3 mars 2023', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">10h30 - 11h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Delporte Gaylord</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">First talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building B</div>', newLine,
'										</div>', newLine,
'								</li>', newLine, newLine"
]

{ #category : 'tests' }
MicAgendaGeneratorTest >> testConvertMicFileCorrectlyWithRealInfo [

	"Look at the class comment for more information about this test"

	"| fs file ast|

	fs := FileSystem memory.
	file := fs root / 'agenda.md'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: self agendaExempleWithRealInfo ].
	
	ast := parser parse: file contents.
	
	writer visit: ast.
	
	self assert: writer contents equals:
'3 mars 2023', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">10h30 - 11h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Delporte Gaylord</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">First talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building B</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">11h00 - 13h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name""></span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Break</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building A</div>', newLine,
'										</div>', newLine,
'								</li>', newLine,
'						<!-- Schedule Details -->', newLine,
'								<li class=""schedule-details"">', newLine,
'										<div class=""block"">', newLine,
'											<!-- time -->', newLine,
'											<div class=""time"">', newLine,
'												<i class=""fa fa-clock-o""></i>', newLine,
'												<span class=""time"">13h00 - 14h00</span>', newLine,
'											</div>', newLine,
'											<!-- Speaker -->', newLine,
'											<div class=""speaker"">', newLine,
'												<!-- <img src=""images/speakers/speaker-thumb-one.jpg"" alt=""speaker-thumb-one""> -->', newLine,
'												<span class=""name"">Not me</span>', newLine,
'											</div>', newLine,
'											<!-- Subject -->', newLine,
'											<div class=""subject"">Second talk</div>', newLine,
'											<!-- Venue -->', newLine,
'											<div class=""venue"">Building C</div>', newLine,
'										</div>', newLine,
'								</li>', newLine, newLine"
	
]

{ #category : 'accessing' }
MicAgendaGeneratorTest >> writer: aWriter [
	writer := aWriter new
]
