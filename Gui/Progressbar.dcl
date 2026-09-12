//------------------------------------------------------------------------------
// Program Name: ProgressBar.dcl [Progress Bar R3]
// Created By:   Terry Miller (Email: terrycadd@yahoo.com)
//               (URL: http://web2.airmail.net/terrycad)
// Date Created: 6-20-04
// Function:     Progress Bar dialog
//------------------------------------------------------------------------------
// Revision History
// Rev  By     Date    Description
//------------------------------------------------------------------------------
// 1    TM    6-20-04  Initial version
// 2    TM    2-20-05  Divided initial function into three functions, ProgressBar,
//                     Progress, and EndProgressBar to be used in loops.
// 3    TM    1-20-07  Updated progress bar dialog design.
//------------------------------------------------------------------------------
// ProgressBar - Progress Bar dialog
//------------------------------------------------------------------------------
ProgressBar : dialog {
  key = "Title";
  label = "";
  spacer;
  : text {
    key = "Message";
    label = "";
  }
  : row {
    : column {
      : spacer { height = 0.12; fixed_height = true;}
      : image {
        key = "ProgressBar";
        width = 58.92; fixed_width = true;
        height = 1.51; fixed_height = true;
        aspect_ratio = 1;
        color = -15;
        vertical_margin = none;
      }
      spacer;
    }
    cancel_button;
  }
  : text {
    key = "Complete";
    label = "";
  }
}// ProgressBar
//------------------------------------------------------------------------------