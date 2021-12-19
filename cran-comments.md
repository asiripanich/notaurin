# Cran Repository Policy

- [x] Reviewed CRP last edited 2021/09/25

Test environments

- [x] Checked locally, R 4.1.1
- [x] Checked on CI system, R 4.1.2
- [x] Checked on win-builder, R devel


## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new submission.


## R CMD check results on win-builder, R devel

Status: 1 NOTE

```
Possibly misspelled words in DESCRIPTION:
  AURIN (2:15, 5:48, 5:72, 6:32, 6:52)
  socio (8:46)
  wellbeing (8:35)
```

I can confirm that those words were not misspelled.

## CRAN's comments from the previous submission

>   The Title field should be in title case. Current version is:
>   'Access Datasets from The 'AURIN' API'
>   In title case that is:
>   'Access Datasets from the 'AURIN' API'

Fixed.