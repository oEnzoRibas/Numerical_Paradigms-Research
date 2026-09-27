#------------------------------------------------------------------------------#
# Modelo Discertacao Profmat
# Autor: Luis Alberto D'Afonseca
# 
# Makefile para compilar a dissertacao gerando um arquivo PDF
# Esse arquivo so e util em sistemas Linux com o rubber instalado
#------------------------------------------------------------------------------#

# Build target
#------------------------------------------------------------------------------#

TARGET= dissertacao
RUBBER= rubber --inplace --short --pdf

default: ${TARGET}.pdf

${TARGET}.pdf: $(wildcard *.tex)     \
               $(wildcard *.cls)     \
	       $(wildcard *.sty)     \
	       $(wildcard *.bib)     \
	       $(wildcard ./figs/*)
	${RUBBER} ${TARGET}.tex

# Distribution
#------------------------------------------------------------------------------#

NUCLEO= cefet

DIST_DATE_ZIP=`date +'%Y%m%d'`
DIST_DATE_CLS=`date +'%Y/%m/%d'`
DIST_DATE_TEX=`date +'{%d}{%m}{%Y}'`

DIST_DIR=latex-profmat-${NUCLEO}-${DIST_DATE_ZIP}
DIST_ZIP=${DIST_DIR}.zip

COPY_FILES= ${TARGET}.tex figs *.tex *.bib *.cwl

CLS_FILE=profmat-${NUCLEO}.cls
TEX_FILE=${TARGET}.tex

.PHONY: dist
dist: distclean
	mkdir -p ${DIST_DIR}
	cp -Lr ${COPY_FILES} ${DIST_DIR}
	cat ${CLS_FILE} | sed     "s|0000/00/00|${DIST_DATE_CLS}|" > ${DIST_DIR}/${CLS_FILE}
	cd ${DIST_DIR}             ; \
	   ${RUBBER} ${TARGET}.tex ; \
     ${RM_TMP_FILES}
	zip -r9 ${DIST_ZIP} ${DIST_DIR}

# Cleaning
#------------------------------------------------------------------------------#

RM_TMP_FILES=rm -vf *~ .*~ *.bak                                    \
                    *.aux *.bbl *.blg *.lof *.log *.lot *.out *.toc \
                    *.bcf *.run.xml *.snm *.nav *.vrb               \
                    *.psynctex.gz *.synctex.gz *.rubbercache

.PHONY: clean
clean:
	-@ ${RM_TMP_FILES}
	-@ rm -vfr ${DIST_DIR} 
	-@ make -C testes clean

.PHONY: distclean
distclean: clean
	-@ rm -vf .*.sw?
	-@ rm -vfr ${DIST_DIR}
	-@ rm -vf  ${TARGET}.pdf
	-@ make -C testes distclean

#------------------------------------------------------------------------------#
