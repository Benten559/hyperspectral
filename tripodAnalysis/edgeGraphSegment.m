function [BW,maskedImage] = segmentImage(RGB)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(RGB) segments image RGB using
%  auto-generated code from the imageSegmenter app. The final segmentation
%  is returned in BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 21-Jul-2021
%----------------------------------------------------


% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Graph cut
foregroundInd = [413191 413194 413197 413201 413204 415237 415254 416258 417305 418305 418329 422398 422427 425468 426524 431609 431646 435702 436768 439798 440867 444916 448036 449011 454129 454181 457199 460271 460327 463342 464424 469485 470569 472557 474665 477677 478701 478761 479785 482797 485929 486893 489965 492073 497133 500205 500267 505327 505387 509423 511531 516593 516651 517675 522795 524789 525867 532009 534007 537128 539129 540155 541224 543227 546305 546342 547329 547331 549379 549414 551427 554499 554531 556547 557603 558597 559622 560646 560674 562696 563722 563744 564748 564749 564751 564753 564756 564758 564761 564764 564766 ];
backgroundInd = [6292 6295 6297 6299 6301 6302 6304 6305 6307 6309 7787 7788 7792 7795 7797 7799 7800 7802 7804 7807 7809 7810 7811 7812 7813 7815 7818 7819 7821 7824 7826 7828 7829 7830 7833 7834 7837 7839 7841 7844 7848 7855 8321 8323 8328 8331 8334 8337 8882 8885 8886 8888 8890 8891 8892 8897 8898 8903 8906 8909 8911 8912 8914 8915 9342 9344 9943 9946 9951 9952 9953 9955 9956 9958 9962 9966 9969 9970 9972 9973 9975 11287 11378 11379 11381 11382 11385 11386 11388 11390 20460 62455 196618 198666 199690 201738 203786 205834 208907 209931 211979 214027 215052 216076 217100 218124 219148 221196 222220 223244 224268 225292 228366 231438 233486 236558 238606 509961 792587 793611 794635 795659 799755 802827 805899 807947 809995 811019 812043 814091 815115 816140 817164 819212 820236 822284 823308 825356 826380 827404 830476 832524 834572 835596 837644 840716 842764 843788 845836 847884 849932 851980 853004 855052 859148 860172 862220 1027088 1033382 1033385 1033387 1033388 1033390 1033392 1033394 1033395 1033397 1033398 1033399 1033401 1034406 1034426 1034428 1034429 1034431 1034432 1034433 1034434 1034438 1034441 1034443 1034445 1034446 1034448 1034450 1034451 1034455 1034458 1034460 1034461 1034463 1034464 1034465 1034467 1034468 1034469 1034470 1034472 1034474 1034477 1034480 1034481 1034483 1034486 1034488 1034492 1034494 1034496 1034499 1034503 1034504 1034506 1034508 1035404 1035406 1035408 1035409 1035411 1035413 1035414 1035416 1035419 1035422 1035424 1035425 1035427 1036086 1036087 1036089 1036091 1036094 1036097 1036098 1036101 1036102 1036104 1036106 1036269 1036557 1036560 1036561 1036564 1036566 1037102 1037105 1037108 1038068 1038069 1038070 1038072 1038074 1038075 1038076 1038077 1038079 1038080 1038081 1038086 1038089 1038091 1038092 1038094 1038096 1038099 1038101 1038104 1038108 1038110 1038113 1038117 1038120 1038123 ];
L = superpixels(X,5343,'IsInputLab',true);

% Convert L*a*b* range to [0 1]
scaledX = prepLab(X);
BW = lazysnapping(scaledX,L,foregroundInd,backgroundInd);

% Erode mask with rectangle
dimensions = [60 60];
d2 = [20 35];
se = strel('rectangle', d2);
se2 = strel('rectangle',dimensions);
BW = imerode(BW,se);
BW = imerode(BW, se2);


% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

function out = prepLab(in)

% Convert L*a*b* image to range [0,1]
out = in;
out(:,:,1) = in(:,:,1) / 100;  % L range is [0 100].
out(:,:,2) = (in(:,:,2) + 86.1827) / 184.4170;  % a* range is [-86.1827,98.2343].
out(:,:,3) = (in(:,:,3) + 107.8602) / 202.3382;  % b* range is [-107.8602,94.4780].

end
