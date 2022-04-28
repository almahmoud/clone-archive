{{/*
Get unique name for extra files
*/}}
{{- define "cloner.getExtraFilesUniqueName" -}}
{{- (printf "%s" (include "cloner.makeDnsCompliant" (printf "extra-%s-%s" (include "cloner.getFilenameFromPath" .) (. | sha256sum))))  }}
{{- end -}}


{{/*
Extract the filename portion from a file path
*/}}
{{- define "cloner.getFilenameFromPath" -}}
{{- printf "%s" (. | splitList "/" | last) -}}
{{- end -}}


{{/*
Make string DNS-compliant by turning to lowercase then removing all noncompliant characters
*/}}
{{- define "cloner.makeDnsCompliant" -}}
{{- (printf "%s" (regexReplaceAll "[^a-z0-9-]" (. | lower) "")) | trunc 63 | trimSuffix "-"  }}
{{- end -}}

