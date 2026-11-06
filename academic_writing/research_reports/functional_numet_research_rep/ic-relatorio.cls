%------------------------------------------------------------------------------%
%
%   Classe LaTeX para formatar relatórios de IC
%
%   Edite este arquivo apenas se tiver certeza do que está fazendo!
%
% Luis Alberto D'Afonseca
% luis.dafonseca@gmail.com
%
%------------------------------------------------------------------------------%
%
% Esta classe herda as seguintes opções da classe base
%    - draft   - Produz uma versão de rascunho
%    - fleqn   - Alinha as equações a esquerda
%
%------------------------------------------------------------------------------%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ic-relatorio}[0000/00/00 CEFET-MG Report LaTeX Class]

% Package Options
%------------------------------------------------------------------------------%

% Add extra functionalities
\RequirePackage{etoolbox}
\RequirePackage{xparse}

% Default options
\newcommand*{\@DefUniv}{}
\newtoggle{@SHORT}

\newcommand*{\@TEXTMODE}{final}
\newcommand*{\@EQNALINEMENT}{}

% Text formatting options
\DeclareOption{short}{\toggletrue{@SHORT}}
\DeclareOption{draft}{\renewcommand*{\@TEXTMODE}    {draft}}
\DeclareOption{fleqn}{\renewcommand*{\@EQNALINEMENT}{fleqn}}

\DeclareOption*
{
  \PackageWarning{profmat-cefet}{Unknown ‘\CurrentOption’}
}

\ProcessOptions\relax

% Load base class: book
\LoadClass[12pt,a4paper,onecolumn,notitlepage,oneside,openany,\@TEXTMODE,\@EQNALINEMENT]{book}

% Packages to pt_BR localization
%------------------------------------------------------------------------------%

\RequirePackage[utf8]{inputenc}
\RequirePackage[english,brazil]{babel}
\RequirePackage{indentfirst}
\RequirePackage{icomma}
\RequirePackage{csquotes}

% Packages to add fonts and fix typesetting
%------------------------------------------------------------------------------%

\RequirePackage{cmap}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[final]{microtype}

\raggedbottom

% Add bibliography to table of contents
\RequirePackage[nottoc,notlot,notlof]{tocbibind}

% Adjust line spacings
%------------------------------------------------------------------------------%

% Line spacing control
\RequirePackage[nodisplayskipstretch]{setspace}

% Sets line spacing for preambule
\setstretch{1.0}

\usepackage{enumitem}
\setlist{nosep}

% To add images
%------------------------------------------------------------------------------%

\RequirePackage{tikz}

% Add images
\RequirePackage{graphicx}

% To improve floats positioning
\def\fps@figure{htbp}
\def\fps@table{htbp}
\setcounter{topnumber}{4}
\setcounter{bottomnumber}{4}
\setcounter{totalnumber}{10}
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.70}
\renewcommand{\floatpagefraction}{0.66}

\setcounter   {dbltopnumber}           {2}
\renewcommand*{\dbltopfraction}        {1}
\renewcommand*{\dblfloatpagefraction}{0.9}

% Caption configuration options
\RequirePackage[
  width=0.96\linewidth,
  justification=centerlast,
  labelfont=bf]{caption}

% Force floats to be on the original section
\RequirePackage[below]{placeins}

% Configurations and packages
%------------------------------------------------------------------------------%

% Allow margin adjustment
\RequirePackage{changepage}

% Allow inclusion of pdf pages on final document
\RequirePackage{pdfpages}

% Allow to comment parts of text
\RequirePackage{comment}

% Allow absolute positioning of elements on a page
\RequirePackage[absolute]{textpos}

% More options to table configuration
\RequirePackage{array}

% Page Geometry
%------------------------------------------------------------------------------%

% Margin adjustment
\RequirePackage[a4paper,margin=25mm,top=30mm,bottom=20mm]{geometry}

% Text formatting
%------------------------------------------------------------------------------%

\setlength{\parindent}{1.25cm}

% Section numbering level
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

% Chapter title configuration
\RequirePackage[bf,rm,compact,raggedright]{titlesec}
\font\bigrm = cmr10 at 35pt
\titleformat{\chapter}[hang]
            {\normalfont\huge\raggedright\setstretch{1.1}}
            {\textbf{\bigrm{\thechapter}}}
            {.7em}
            {\bfseries}
            [{\vspace{-5mm}\hrulefill\\[.8ex]}]
\titlespacing{\chapter}{0cm}{0.5cm}{1.5cm}

% Bug fix for titlesec version 2.10.1
% https://bugs.launchpad.net/ubuntu/+source/texlive-extra/+bug/1574052
\@ifpackagelater{titlesec}{2016/03/21}{}
{
  \patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}
  \patchcmd{\ttlh@hang}{\noindent}{}{}{}
}

% Page header configuration
\RequirePackage{fancyhdr}
\renewcommand*{\chaptermark}[1]{\markboth{\thechapter.\ #1}{} }
\renewcommand*{\sectionmark}[1]{\markright{\thesection\ #1}}
\lhead[\fancyplain{}{\bfseries\thepage}]
      {\fancyplain{}{\small\slshape\bfseries{\nouppercase{\leftmark}}}}
\rhead[\fancyplain{}{\small\slshape\bfseries{\nouppercase{\rightmark}}}]
      {\fancyplain{}{\bfseries\thepage}}
\cfoot[\fancyplain{\bfseries\thepage}{}]
      {\fancyplain{\bfseries\thepage}{}}
\renewcommand*{\headrulewidth}{0.3pt}

\setlength{\headheight}{15pt}

% Appendix and annex parts
%------------------------------------------------------------------------------%

\renewcommand{\appendix}%
{%
\renewcommand{\chaptername}{Ap\^endice}
\renewcommand{\thechapter}{\Alph{chapter}}
%
\titleformat{\chapter}[display]
            {\normalfont\huge\raggedright\setstretch{1.1}}
            {\textbf{Ap\^endice \thechapter}}
            {0pt}
            {\bfseries}
            [{\vspace{-5mm}\hrulefill\\[.8ex]}]
%
\addtocontents{toc}{\protect{\par\vspace{\baselineskip}\noindent{\textbf{Ap\^endices}}\par}}
\setcounter{chapter}{0}
}

\newcommand{\annex}%
{%
\titleformat{\chapter}[display]
            {\normalfont\huge\raggedright\setstretch{1.1}}
            {\textbf{Anexo \thechapter}}
            {0pt}
            {\bfseries}
            [{\vspace{-5mm}\hrulefill\\[.8ex]}]
%
\addtocontents{toc}{\protect{\par\vspace{\baselineskip}\noindent{\textbf{Anexos}}\par}}
\setcounter{chapter}{0}
\setcounter{section}{0}
%
\renewcommand{\chaptername}{Anexo}
\renewcommand{\thechapter}{\Roman{chapter}}
\renewcommand{\theHchapter}{annex.\thechapter}
}

% To create Hyperlinks on pdf file
%------------------------------------------------------------------------------%

% Create hyperlinks and set nice colors
\RequirePackage[colorlinks=true,
                linktocpage=true,
                linkcolor=blue,
                urlcolor=blue,
                hypertexnames=false,
                citecolor=blue]{hyperref}

\urlstyle{sf}

% Redefining quote and quotation to format text to italic
%------------------------------------------------------------------------------%

\renewenvironment{quote}
{%
  \setlength{\parindent}{0pt}%
  \begin{adjustwidth}{4cm}{0pt}%
    \begin{small}%
}
{%
    \end{small}%
  \end{adjustwidth}%
}

\renewenvironment{quotation}
{%
  \setlength{\parindent}{0pt}%
  \begin{adjustwidth}{4cm}{0pt}%
    \begin{small}%
    \setlength{\parskip}{0.5\baselineskip}%
}
{%
    \end{small}%
  \end{adjustwidth}%
}

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%
%                       University Dependent Contend
%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

\newcommand*{\TheUNI}       {UFCIMG}
\newcommand*{\ThePlace}     {Belo Horizonte}
\newcommand*{\TheUniversity}{Federal University of Science and Technology of Minas Gerais}

\newcommand{\@DrawUNILogo}
{
  \definecolor{c004279}{RGB}{0,66,121}
  \def \globalscale {1.000000}
  \begin{tikzpicture}[y=0.80pt, x=0.80pt, yscale=-\globalscale, xscale=\globalscale, inner sep=0pt, outer sep=0pt]
  \begin{scope}[shift={(-101.65891,-256.28363)},fill=c004279]
  \path[fill=c004279,even odd rule]
             (160.2752,348.6600) --  (175.5969,348.6600) -- (174.7414,352.6205) --
             (165.8578,352.6205) --  (164.9151,357.2315) -- (173.4195,357.2315) --
             (172.5793,361.2226) --  (164.0439,361.2226) -- (162.2098,369.9889) --
             (155.7254,369.9889) --  (160.2752,348.6600) --
    cycle    (210.6948,358.5311) --  (216.8959,358.5311) -- (216.0555,362.4045) --
             (209.8546,362.4045) --  (210.6948,358.5311) --
    cycle    (140.8443,344.3285) --  (139.2048,349.1037) ..
    controls (135.3563,348.1321) and (130.6018,347.9459) .. (127.2197,349.1649) ..
    controls (119.4029,351.9833) and (118.2351,363.7836) .. (127.7976,365.1200) ..
    controls (130.5637,365.4642) and (134.5431,365.2735) .. (136.9555,364.0360) --
             (135.5815,370.1771) ..
    controls (130.0766,371.5732) and (121.9788,371.2730) .. (116.9553,368.3983) ..
    controls (109.5607,364.1680) and (110.6005,354.2979) .. (115.8328,348.7461) ..
    controls (121.4054,342.8331) and (132.0540,341.9899) .. (140.8443,344.3285) --
    cycle    (177.7861,348.6600) --  (193.6055,348.6600) -- (192.7500,352.6205) --
             (183.1338,352.6205) --  (182.2474,356.8984) -- (191.3103,356.8984) --
             (190.5007,360.7411) --  (181.4224,360.7411) -- (180.2426,365.9976) ..
    controls (185.1050,366.0897) and (186.5336,365.9838) .. (190.1032,365.8998) --
             (189.4044,369.9889) --  (173.2363,369.9889) -- (177.7861,348.6600) --
    cycle    (275.9776,347.1539) --  (275.9515,347.2303) -- (275.9776,347.2393) --
             (275.9772,347.2413) ..
    controls (275.9774,347.2413) and (275.9776,347.2413) .. (275.9776,347.2413) --
             (275.8718,347.4626) --  (274.5428,351.3323) ..
    controls (271.1761,350.4826) and (266.9388,350.3193) .. (263.9805,351.3861) ..
    controls (257.1416,353.8520) and (256.1199,364.1754) .. (264.4863,365.3449) ..
    controls (265.3158,365.4482) and (266.7400,365.4961) .. (267.6525,365.4714) --
             (268.6861,360.6582) --  (264.8417,360.6582) -- (264.8421,360.6562) --
             (264.8417,360.6562) --  (265.7495,356.5962) ..
    controls (267.9820,356.5745) and (268.9470,356.6100) .. (275.2920,356.4833) ..
    controls (274.3410,360.9247) and (273.6601,364.8818) .. (272.7104,369.3278) ..
    controls (272.2795,369.4694) and (271.8379,369.5981) .. (271.3855,369.7146) --
             (271.3732,369.7692) ..
    controls (269.5004,370.2441) and (267.2849,370.4937) .. (265.0173,370.4748) ..
    controls (264.9055,370.4758) and (264.7924,370.4768) .. (264.6791,370.4768) ..
    controls (263.6527,370.4768) and (262.6902,370.4048) .. (261.7897,370.2615) ..
    controls (259.3193,369.9492) and (257.2128,369.2869) .. (255.3373,368.2135) ..
    controls (248.8677,364.5117) and (249.7774,355.8766) .. (254.3555,351.0194) ..
    controls (257.4578,347.7279) and (262.0979,346.2327) .. (267.2332,346.1071) --
             (267.3383,346.1041) ..
    controls (267.6348,346.0951) and (267.9365,346.0905) .. (268.2435,346.0905) ..
    controls (269.6558,346.0905) and (271.0011,346.1853) .. (272.2844,346.3705) ..
    controls (272.9558,346.4675) and (273.6154,346.5948) .. (274.2615,346.7500) ..
    controls (274.8407,346.8697) and (275.4134,347.0038) .. (275.9776,347.1539) --
    cycle    (195.5937,348.6600) --  (212.6386,348.6600) -- (211.7523,352.7742) --
             (206.5715,352.7742) --  (202.9082,369.9889) -- (196.3572,369.9889) --
             (200.0205,352.7742) --  (194.7382,352.7742) -- (195.5937,348.6600) --
    cycle    (223.3844,346.6677) --  (233.3183,346.6677) -- (233.8283,358.5209) ..
    controls (233.8391,358.7729) and (233.8453,359.0367) .. (233.8508,359.3167) ..
    controls (233.8568,359.5969) and (233.8619,359.9500) .. (233.8619,360.3761) ..
    controls (233.8619,360.7400) and (233.8506,361.1550) .. (233.8340,361.6257) ..
    controls (233.8172,362.0964) and (233.7949,362.6230) .. (233.7611,363.2004) ..
    controls (233.9684,362.4999) and (234.2286,361.7590) .. (234.5401,360.9758) ..
    controls (234.8507,360.1954) and (235.2268,359.3460) .. (235.6498,358.4257) --
             (241.0526,346.6677) --  (251.3451,346.6677) -- (246.3068,369.9987) --
             (240.2792,369.9987) ..
    controls (241.6234,363.5621) and (242.7666,357.3047) ..
             (244.4824,350.9520) --  (244.5469,350.9520) -- (235.4674,369.9987) --
             (229.1964,369.9987) --  (228.3611,351.2124) -- (228.3416,351.2124) ..
    controls (227.2088,357.6927) and (225.7723,363.5655) .. (224.3847,369.9987) --
             (218.3964,369.9987) --  (223.3844,346.6677) --
    cycle    (142.1958,348.6600) --  (158.0153,348.6600) -- (157.1598,352.6205) --
             (147.5435,352.6205) --  (146.6572,356.8984) -- (155.7201,356.8984) --
             (154.9105,360.7411) --  (145.8321,360.7411) -- (144.6524,365.9976) ..
    controls (149.5147,366.0897) and (150.9434,365.9838) .. (154.5129,365.8998) --
             (153.8141,369.9889) --  (137.6460,369.9889) -- (142.1958,348.6600) --
    cycle;
  \path[fill=c004279,even odd rule]
             (186.3326,288.2728) ..
    controls (186.4272,288.2480) and (186.5035,288.2046) .. (186.5767,288.1763) ..
    controls (187.1950,287.9362) and (186.9110,287.3581) .. (186.3753,287.4096) ..
    controls (185.7638,287.4683) and (185.1142,287.6079) .. (184.5124,287.7270) ..
    controls (184.1131,287.8059) and (183.7070,287.8956) .. (183.2965,287.9941) ..
    controls (171.3129,290.8733) and (155.4377,301.9900) .. (161.1045,318.0279) ..
    controls (166.4102,329.6990) and (179.7636,333.1180) .. (190.5299,333.4930) ..
    controls (195.0153,333.6533) and (200.4053,333.2596) .. (206.5858,331.9442) ..
    controls (207.8866,331.6678) and (208.8813,331.3134) .. (210.1305,330.5154) --
             (224.0093,320.4071) --  (224.4922,320.0620) ..
    controls (225.0145,319.7108) and (225.5934,319.9042) .. (225.3095,320.6795) ..
    controls (224.9575,321.6407) and (223.9969,322.9029) .. (223.3623,323.7474) ..
    controls (222.8326,324.4519) and (222.2472,325.1097) .. (221.5058,325.8130) ..
    controls (218.4367,328.7873) and (214.8707,331.7214) .. (211.3417,334.0894) ..
    controls (210.1388,334.8967) and (208.8705,335.7049) .. (207.4733,336.1146) ..
    controls (206.3606,336.4504) and (205.2224,336.7395) .. (204.0653,336.9831) ..
    controls (195.3481,338.8192) and (185.5419,338.0929) .. (177.1999,335.6184) ..
    controls (166.3531,332.6839) and (154.3814,322.1047) .. (157.2849,307.6408) ..
    controls (159.3917,296.3795) and (170.7822,289.0661) .. (181.7888,286.0270) ..
    controls (191.0073,283.4817) and (201.0873,284.1092) .. (209.8786,287.9973) ..
    controls (210.7907,288.4008) and (210.6906,288.4172) .. (211.4820,287.8037) --
             (227.9804,275.0121) --  (228.2581,274.8038) ..
    controls (228.8398,274.3902) and (228.7341,273.9933) .. (228.3043,273.7644) ..
    controls (228.0608,273.6348) and (227.8086,273.5168) .. (227.5603,273.3986) ..
    controls (224.6811,272.0288) and (221.6580,271.1138) .. (218.9475,270.4481) ..
    controls (217.9809,270.2108) and (217.0074,269.9841) .. (216.0340,269.7840) ..
    controls (204.2736,267.3633) and (194.2433,269.5995) .. (184.8567,273.6780) ..
    controls (182.7171,274.6076) and (180.6303,275.7540) .. (178.5930,276.8487) ..
    controls (176.4773,278.0774) and (174.1571,279.5354) .. (171.9564,281.0165) ..
    controls (170.8818,281.7399) and (169.8670,282.4796) .. (168.8555,283.1791) ..
    controls (168.2310,283.6779) and (167.6151,282.9414) .. (168.2094,282.3763) ..
    controls (169.0106,281.6146) and (169.8785,280.8375) .. (170.7867,280.0693) ..
    controls (173.3493,277.9022) and (176.2339,275.8063) .. (178.8575,274.3247) ..
    controls (186.4287,270.0489) and (194.9646,267.1449) .. (203.8429,266.4501) ..
    controls (218.0451,265.3394) and (234.7484,269.6673) .. (241.9120,283.0356) ..
    controls (245.6627,290.0357) and (244.4924,296.6706) .. (240.2708,302.1077) ..
    controls (231.4545,313.4625) and (216.3743,317.1698) .. (202.5101,316.9215) ..
    controls (191.6994,316.7279) and (179.8811,313.8694) .. (175.4536,306.9508) ..
    controls (170.6499,299.0105) and (177.6839,292.6297) .. (184.4634,289.0975) ..
    controls (185.0723,288.7811) and (185.6906,288.5235) .. (186.3326,288.2728) --
    cycle;
  \end{scope}
  \end{tikzpicture}
}

%------------------------------------------------------------------------------%

% Defines university place
\newcommand*{\@Place}
{
  \null
  \vfill
  \begin{center}
    \textsc{\ThePlace \\ \@date}
  \end{center}
}
% Dissertation Title
%------------------------------------------------------------------------------%

\newcommand*{\@TheTitle}{Título da Dissertação}
\newcommand*{\@TheTITLE}{TÍTULO DA DISSERTAÇÃO}

\renewcommand*{\title}[1]{\renewcommand*{\@TheTitle}{{#1}}\renewcommand*{\@TheTITLE}{\MakeUppercase{#1}}}

% Dissertation Author
%------------------------------------------------------------------------------%

\newcommand*{\@AuthorTitle}{Autor(a)}
\newcommand*{\@TheAuthor}  {Nome do(a) Autor(a)}

\newcommand*{\autor}[1]
{
  \renewcommand*{\@AuthorTitle}{Autor}
  \renewcommand*{\@TheAuthor}{{#1}}
}
\newcommand*{\autora}[1]
{
  \renewcommand*{\@AuthorTitle}{Autora}
  \renewcommand*{\@TheAuthor}{{#1}}
}

\renewcommand{\author}[1]{\autor{#1}}

% Adiviser
%------------------------------------------------------------------------------%

\newcommand*{\@AdviserTitle}{Orientador(a)}
\newcommand*{\@TheAdviser}{Nome do(a) Orientador(a)}

\newcommand*{\orientador} [1]{ \renewcommand*{\@TheAdviser}{#1} \renewcommand*{\@AdviserTitle}{Orientador}}
\newcommand*{\orientadora}[1]{ \renewcommand*{\@TheAdviser}{#1} \renewcommand*{\@AdviserTitle}{Orientadora}}

% Co-Adviser
%------------------------------------------------------------------------------%

\newtoggle{@COADV}
\togglefalse{@COADV}

\newcommand*{\@coorientacao}[2]%
{%
  \toggletrue{@COADV}
  \newcommand*{\@CoadviserDeclaration}{{#1}\\{#2}}
}

\newcommand{\coorientador}  [1]{\@coorientacao{Coorientador}{#1}}
\newcommand{\coorientadora} [1]{\@coorientacao{Coorientadora}{#1}}
\newcommand{\coorientadores}[1]{\@coorientacao{Coorientadores}{#1}}
\newcommand{\coorientadoras}[1]{\@coorientacao{Coorientadoras}{#1}}

% Dissertation preamble
%------------------------------------------------------------------------------%

% Make Title page
%------------------------------------------------------------------%
\newcommand*{\MakeTitlePage}
{{%
  \hyphenpenalty   10000
  \exhyphenpenalty 10000
  \begin{center}
    % Instituição
    \textsc{\TheUniversity \\[1mm] Scientific Initiation Report} \\[9mm]
    \@DrawUNILogo
    % Título
    \vspace{20mm}
    \begin{spacing}{2}
      \textsc{\LARGE\@TheTitle}
    \end{spacing}
  \end{center}
  \begin{textblock*}{0.7\linewidth}(70mm,165mm)
    % Author
    \noindent\hspace{-0.06\linewidth}\@AuthorTitle \\
    \@TheAuthor\par\vspace{\baselineskip}
    % Orientação
    \noindent\hspace{-0.06\linewidth}\@AdviserTitle\\
    \@TheAdviser\par\vspace{\baselineskip}
    \iftoggle{@COADV}{
      \noindent\hspace{-0.06\linewidth}\@CoadviserDeclaration\par\vspace{\baselineskip}
    }{}
  \end{textblock*}
  \@Place
}}

%------------------------------------------------------------------------------%
\newenvironment{Resumo}
{
  \chapter*{Resumo}
  \markboth{Resumo}{Resumo}
  \noindent\trivlist\item\ignorespaces
}
{
  \endtrivlist
}

\newenvironment{Abstract}
{
  \chapter*{Abstract}
  \markboth{Abstract}{Abstract}
  \begin{otherlanguage}{english}
  \noindent\trivlist\item\ignorespaces
}
{
  \endtrivlist
  \end{otherlanguage}
}

\newcommand*{\PalavrasChave}{\par\vspace{\baselineskip}\noindent Palavras-chave: }
\newcommand*{\Keywords}     {\par\vspace{\baselineskip}\noindent Keywords: }

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%
%                End of University Dependent Contend
%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%

% Make Preamble
%------------------------------------------------------------------------------%
\AtBeginDocument
{%
  \pagestyle{empty}%
  \assignpagestyle{\chapter}{empty}%
  \MakeTitlePage%
  \clearpage%
}

% Closes the preamble
%------------------------------------------------------------------------------%

\let\OriginalTableOfContents\tableofcontents

\renewcommand*{\tableofcontents}
{
  \clearpage
  \OriginalTableOfContents
  \@openrighttrue
  \clearpage
  \pagestyle{fancyplain}
  \assignpagestyle{\chapter}{plain}
  \setstretch{1.15}
}

% Bibligraphy using biblatex
%------------------------------------------------------------------------------%

\RequirePackage[backend=biber,%
                ittitles,%
                giveninits=true,%
                justify,%
                indent,%
                scbib,%
                repeatfields,%
                comp,%
                noslsn,%
                natbib=true,%
                style=abnt-numeric]{biblatex}

\AtEveryCite{%
  \let\parentext=\parentexttrack%
  \let\bibopenparen=\bibopenbracket%
  \let\bibcloseparen=\bibclosebracket}

\renewcommand*{\bibfont}{\small}
\appto{\bibsetup}{\sloppy}

\let\oldprintbibliography\printbibliography

\renewcommand{\printbibliography}{
\begingroup
  \setstretch{0.9}
  \oldprintbibliography[title=Referências,heading=bibintoc]
\endgroup
}

\AtBeginBibliography{\vspace{-2\baselineskip}}

\renewcommand{\textcite}[2][]{\citeauthor{#2} \cite[#1]{#2}}

% Commands to add figures source
%------------------------------------------------------------------------------%
\newcommand{\fonte}    [1]{\par\noindent Fonte: #1}
\newcommand{\fonteCite}[2]{\par\noindent Fonte: #1 \cite{#2}.}
\newcommand{\fonteUrl} [1]{\par\noindent Fonte: \url{#1}.}
\newcommand{\fonteAutor}  {\par\noindent Fonte: Próprio autor.}

%------------------------------------------------------------------------------%
\endinput
%------------------------------------------------------------------------------%
