(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["main"],{

/***/ "./$$_lazy_route_resource lazy recursive":
/*!******************************************************!*\
  !*** ./$$_lazy_route_resource lazy namespace object ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncaught exception popping up in devtools
	return Promise.resolve().then(function() {
		var e = new Error("Cannot find module '" + req + "'");
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "./$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "./node_modules/raw-loader/index.js!./src/app/app.component.html":
/*!**************************************************************!*\
  !*** ./node_modules/raw-loader!./src/app/app.component.html ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div class=\"application-grid\">\r\n  <nav class=\"sidebar\">\r\n    <div class=\"user-box\">\r\n      <img\r\n        src=\"assets/img/user.jpg\"\r\n        alt=\"User picture\"\r\n        class=\"user-box__avatar\"\r\n      />\r\n      <span class=\"user-box__username\">Name</span>\r\n    </div>\r\n    <a class=\"option\">\r\n      <svg class=\"option__icon\">\r\n        <use xlink:href=\"assets/img/SVG/sprite.svg#icon-bubble\"></use>\r\n      </svg>\r\n    </a>\r\n    <a class=\"option\">\r\n      <svg class=\"option__icon\">\r\n        <use xlink:href=\"assets/img/SVG/sprite.svg#icon-cog\"></use>\r\n      </svg>\r\n    </a>\r\n    <a class=\"option\">\r\n      <svg class=\"option__icon\">\r\n        <use xlink:href=\"assets/img/SVG/sprite.svg#icon-exit\"></use>\r\n      </svg>\r\n    </a>\r\n  </nav>\r\n  <div class=\"chats\">\r\n    <h2 class=\"chats__title\">CHATS</h2>\r\n    <div class=\"chat-preview chat-preview--active\">\r\n      <img\r\n        class=\"chat-preview__avatar\"\r\n        src=\"assets/img/bot2.png\"\r\n        alt=\"Bot avatar\"\r\n      />\r\n      <div class=\"chat-preview__text\">\r\n        <span class=\"chat-preview__botname\">\r\n          R2-D2\r\n        </span>\r\n        <p class=\"chat-preview__message\">\r\n          How are you doing? :)\r\n        </p>\r\n      </div>\r\n    </div>\r\n    <div class=\"chat-preview\">\r\n      <img\r\n        class=\"chat-preview__avatar\"\r\n        src=\"assets/img/bot1.png\"\r\n        alt=\"Bot avatar\"\r\n      />\r\n      <div class=\"chat-preview__text\">\r\n        <span class=\"chat-preview__botname\">\r\n          C-3PO\r\n        </span>\r\n        <p class=\"chat-preview__message\">\r\n          Good bye!\r\n        </p>\r\n      </div>\r\n    </div>\r\n  </div>\r\n  <div class=\"chat\">\r\n    <h1 class=\"chat__botname\">R2-D2</h1>\r\n    <div class=\"messages\">\r\n      <div\r\n        *ngFor=\"let message of messages\"\r\n        class=\"message-box\"\r\n        [ngClass]=\"'message-box--'.concat(message.owner | lowercase)\"\r\n      >\r\n        <img\r\n          class=\"message-box__picture\"\r\n          [ngClass]=\"'message-box__picture--'.concat(message.owner | lowercase)\"\r\n          [src]=\"\r\n            (message.owner | lowercase) == 'bot' ? botPicture : userPicture\r\n          \"\r\n          alt=\"Bot picture\"\r\n        />\r\n        <div\r\n          class=\"message-box__message message-box__message--bot\"\r\n          [ngClass]=\"'message-box__message--'.concat(message.owner | lowercase)\"\r\n        >\r\n          <span> {{ message.body }}</span>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <div class=\"typer\">\r\n      <input\r\n        (keyup.enter)=\"onSendMessage($event.target)\"\r\n        class=\"typer__input\"\r\n        type=\"text\"\r\n        placeholder=\"Type something...\"\r\n      />\r\n      <svg class=\"typer__button\">\r\n        <use xlink:href=\"assets/img/SVG/sprite.svg#icon-circle-right\"></use>\r\n      </svg>\r\n    </div>\r\n  </div>\r\n</div>\r\n"

/***/ }),

/***/ "./src/app/app-routing.module.ts":
/*!***************************************!*\
  !*** ./src/app/app-routing.module.ts ***!
  \***************************************/
/*! exports provided: AppRoutingModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppRoutingModule", function() { return AppRoutingModule; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_router__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/router */ "./node_modules/@angular/router/fesm5/router.js");



var routes = [];
var AppRoutingModule = /** @class */ (function () {
    function AppRoutingModule() {
    }
    AppRoutingModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["NgModule"])({
            imports: [_angular_router__WEBPACK_IMPORTED_MODULE_2__["RouterModule"].forRoot(routes)],
            exports: [_angular_router__WEBPACK_IMPORTED_MODULE_2__["RouterModule"]]
        })
    ], AppRoutingModule);
    return AppRoutingModule;
}());



/***/ }),

/***/ "./src/app/app.component.scss":
/*!************************************!*\
  !*** ./src/app/app.component.scss ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = ".application-grid {\n  display: grid;\n  grid-template-columns: 11rem 27.5rem 85rem;\n}\n\n.sidebar {\n  background-color: #303841;\n  display: flex;\n  flex-direction: column;\n}\n\n.sidebar .user-box {\n  color: #fff;\n  padding: 1.5rem 0;\n  display: flex;\n  align-items: center;\n  justify-content: center;\n  flex-direction: column;\n}\n\n.sidebar .user-box__avatar {\n  border-radius: 50%;\n  height: 4.5rem;\n  margin-bottom: 0.75rem;\n}\n\n.sidebar .user-box__username {\n  font-size: 1.4rem;\n}\n\n.sidebar .option {\n  cursor: pointer;\n  padding: 1rem 0;\n  display: flex;\n  justify-content: center;\n  align-items: center;\n  transition: background-color 0.2s;\n}\n\n.sidebar .option:hover {\n  background-color: #434c57;\n}\n\n.sidebar .option:active {\n  background-color: #4b5561;\n}\n\n.sidebar .option__icon {\n  fill: #a5b5c1;\n  width: 2.5rem;\n  height: 2.5rem;\n}\n\n.sidebar .option:last-child {\n  margin-top: auto;\n}\n\n.chats {\n  background-color: #434c57;\n  color: #fff;\n}\n\n.chats__title {\n  text-align: center;\n  padding: 1rem 0;\n}\n\n.chats .chat-preview {\n  cursor: pointer;\n  padding: 1rem;\n  display: flex;\n  align-items: center;\n  transition: background-color 0.2s;\n}\n\n.chats .chat-preview:hover, .chats .chat-preview--active {\n  background-color: #5d6977;\n}\n\n.chats .chat-preview:active {\n  background-color: #505b68;\n}\n\n.chats .chat-preview__avatar {\n  height: 4rem;\n  border-radius: 50%;\n  margin-right: 1.5rem;\n}\n\n.chats .chat-preview__text {\n  display: flex;\n  flex-direction: column;\n}\n\n.chats .chat-preview__botname {\n  font-size: 1.7rem;\n}\n\n.chats .chat-preview__message {\n  font-size: 1.5rem;\n}\n\n.chat {\n  background-color: #f2f7f7;\n  color: #888888;\n  display: grid;\n  grid-template-rows: auto 47.5rem auto;\n}\n\n.chat__botname {\n  text-transform: uppercase;\n  justify-self: center;\n  border-bottom: 2px solid rgba(187, 182, 182, 0.329);\n  padding: 1rem;\n}\n\n.chat .messages {\n  padding: 1rem;\n  overflow: auto;\n  position: relative;\n  bottom: 0;\n}\n\n.chat .messages .message-box {\n  display: flex;\n  align-items: center;\n}\n\n.chat .messages .message-box:not(:last-child) {\n  margin-bottom: 1.25rem;\n}\n\n.chat .messages .message-box--user {\n  flex-direction: row-reverse;\n}\n\n.chat .messages .message-box__picture {\n  height: 5rem;\n  border-radius: 50%;\n}\n\n.chat .messages .message-box__picture--bot {\n  margin-right: 1.5rem;\n}\n\n.chat .messages .message-box__picture--user {\n  margin-left: 1.5rem;\n}\n\n.chat .messages .message-box__message {\n  box-shadow: 0px 6px 23px -6px rgba(0, 0, 0, 0.24);\n  font-size: 1.5rem;\n  padding: 1rem;\n  max-width: calc(100% - (2 * 8rem));\n  word-break: break-all;\n}\n\n.chat .messages .message-box__message--bot {\n  background-color: #fff;\n}\n\n.chat .messages .message-box__message--user {\n  background-color: #54d38a;\n  color: #fff;\n}\n\n.chat .typer {\n  background-color: #fff;\n  display: flex;\n  align-items: center;\n}\n\n.chat .typer__input {\n  border: none;\n  outline: none;\n  font-size: 1.8rem;\n  flex: 0 0 90%;\n  padding: 1.5rem 1rem;\n}\n\n.chat .typer__button {\n  cursor: pointer;\n  fill: #a5b5c1;\n  width: 2.25rem;\n  height: 2.25rem;\n  flex: 0 0 10%;\n  transition: fill 0.2s;\n}\n\n.chat .typer__button:hover {\n  fill: #747f88;\n}\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9hcHAvQzpcXFVzZXJzXFxMb0xFUlxcT25lRHJpdmUgLSBVbml2ZXJzaWRhZCBOYWNpb25hbCBkZSBDb3N0YSBSaWNhXFxEb2N1bWVudG9zXFxQcm95ZWN0by1QYXJhZGlnbWFzLUcwMy0zcG1cXEFuZ3VsYXIgU1BBL3NyY1xcYXBwXFxhcHAuY29tcG9uZW50LnNjc3MiLCJzcmMvYXBwL2FwcC5jb21wb25lbnQuc2NzcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtFQUNFLGFBQUE7RUFDQSwwQ0FBQTtBQ0NGOztBREVBO0VBQ0UseUJBQUE7RUFDQSxhQUFBO0VBQ0Esc0JBQUE7QUNDRjs7QURDRTtFQUNFLFdBQUE7RUFDQSxpQkFBQTtFQUVBLGFBQUE7RUFDQSxtQkFBQTtFQUNBLHVCQUFBO0VBQ0Esc0JBQUE7QUNBSjs7QURFSTtFQUNFLGtCQUFBO0VBQ0EsY0FBQTtFQUNBLHNCQUFBO0FDQU47O0FER0k7RUFDRSxpQkFBQTtBQ0ROOztBREtFO0VBQ0UsZUFBQTtFQUNBLGVBQUE7RUFDQSxhQUFBO0VBQ0EsdUJBQUE7RUFDQSxtQkFBQTtFQUNBLGlDQUFBO0FDSEo7O0FES0k7RUFDRSx5QkFBQTtBQ0hOOztBRE1JO0VBQ0UseUJBQUE7QUNKTjs7QURPSTtFQUNFLGFBQUE7RUFDQSxhQUFBO0VBQ0EsY0FBQTtBQ0xOOztBRFFJO0VBQ0UsZ0JBQUE7QUNOTjs7QURXQTtFQUNFLHlCQUFBO0VBQ0EsV0FBQTtBQ1JGOztBRFVFO0VBQ0Usa0JBQUE7RUFDQSxlQUFBO0FDUko7O0FEVUU7RUFDRSxlQUFBO0VBQ0EsYUFBQTtFQUNBLGFBQUE7RUFDQSxtQkFBQTtFQUNBLGlDQUFBO0FDUko7O0FEVUk7RUFFRSx5QkFBQTtBQ1ROOztBRFlJO0VBQ0UseUJBQUE7QUNWTjs7QURhSTtFQUNFLFlBQUE7RUFDQSxrQkFBQTtFQUNBLG9CQUFBO0FDWE47O0FEY0k7RUFDRSxhQUFBO0VBQ0Esc0JBQUE7QUNaTjs7QURlSTtFQUNFLGlCQUFBO0FDYk47O0FEZ0JJO0VBQ0UsaUJBQUE7QUNkTjs7QURtQkE7RUFDRSx5QkFBQTtFQUNBLGNBQUE7RUFFQSxhQUFBO0VBQ0EscUNBQUE7QUNqQkY7O0FEbUJFO0VBQ0UseUJBQUE7RUFDQSxvQkFBQTtFQUVBLG1EQUFBO0VBQ0EsYUFBQTtBQ2xCSjs7QURxQkU7RUFDRSxhQUFBO0VBQ0EsY0FBQTtFQUNBLGtCQUFBO0VBQ0EsU0FBQTtBQ25CSjs7QURxQkk7RUFDRSxhQUFBO0VBQ0EsbUJBQUE7QUNuQk47O0FEcUJNO0VBQ0Usc0JBQUE7QUNuQlI7O0FEc0JNO0VBQ0UsMkJBQUE7QUNwQlI7O0FEdUJNO0VBQ0UsWUFBQTtFQUNBLGtCQUFBO0FDckJSOztBRHVCUTtFQUNFLG9CQUFBO0FDckJWOztBRHdCUTtFQUNFLG1CQUFBO0FDdEJWOztBRDBCTTtFQUNFLGlEQUFBO0VBQ0EsaUJBQUE7RUFDQSxhQUFBO0VBQ0Esa0NBQUE7RUFDQSxxQkFBQTtBQ3hCUjs7QUQwQlE7RUFDRSxzQkFBQTtBQ3hCVjs7QUQyQlE7RUFDRSx5QkFBQTtFQUNBLFdBQUE7QUN6QlY7O0FEK0JFO0VBQ0Usc0JBQUE7RUFFQSxhQUFBO0VBQ0EsbUJBQUE7QUM5Qko7O0FEZ0NJO0VBQ0UsWUFBQTtFQUNBLGFBQUE7RUFDQSxpQkFBQTtFQUNBLGFBQUE7RUFDQSxvQkFBQTtBQzlCTjs7QURpQ0k7RUFDRSxlQUFBO0VBQ0EsYUFBQTtFQUNBLGNBQUE7RUFDQSxlQUFBO0VBQ0EsYUFBQTtFQUNBLHFCQUFBO0FDL0JOOztBRGlDTTtFQUNFLGFBQUE7QUMvQlIiLCJmaWxlIjoic3JjL2FwcC9hcHAuY29tcG9uZW50LnNjc3MiLCJzb3VyY2VzQ29udGVudCI6WyIuYXBwbGljYXRpb24tZ3JpZCB7XHJcbiAgZGlzcGxheTogZ3JpZDtcclxuICBncmlkLXRlbXBsYXRlLWNvbHVtbnM6IDExcmVtIDI3LjVyZW0gODVyZW07XHJcbn1cclxuXHJcbi5zaWRlYmFyIHtcclxuICBiYWNrZ3JvdW5kLWNvbG9yOiAjMzAzODQxO1xyXG4gIGRpc3BsYXk6IGZsZXg7XHJcbiAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjtcclxuXHJcbiAgLnVzZXItYm94IHtcclxuICAgIGNvbG9yOiAjZmZmO1xyXG4gICAgcGFkZGluZzogMS41cmVtIDA7XHJcblxyXG4gICAgZGlzcGxheTogZmxleDtcclxuICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7XHJcbiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjtcclxuICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47XHJcblxyXG4gICAgJl9fYXZhdGFyIHtcclxuICAgICAgYm9yZGVyLXJhZGl1czogNTAlO1xyXG4gICAgICBoZWlnaHQ6IDQuNXJlbTtcclxuICAgICAgbWFyZ2luLWJvdHRvbTogMC43NXJlbTtcclxuICAgIH1cclxuXHJcbiAgICAmX191c2VybmFtZSB7XHJcbiAgICAgIGZvbnQtc2l6ZTogMS40cmVtO1xyXG4gICAgfVxyXG4gIH1cclxuXHJcbiAgLm9wdGlvbiB7XHJcbiAgICBjdXJzb3I6IHBvaW50ZXI7XHJcbiAgICBwYWRkaW5nOiAxcmVtIDA7XHJcbiAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7XHJcbiAgICBhbGlnbi1pdGVtczogY2VudGVyO1xyXG4gICAgdHJhbnNpdGlvbjogYmFja2dyb3VuZC1jb2xvciAwLjJzO1xyXG5cclxuICAgICY6aG92ZXIge1xyXG4gICAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNDM0YzU3O1xyXG4gICAgfVxyXG5cclxuICAgICY6YWN0aXZlIHtcclxuICAgICAgYmFja2dyb3VuZC1jb2xvcjogIzRiNTU2MTtcclxuICAgIH1cclxuXHJcbiAgICAmX19pY29uIHtcclxuICAgICAgZmlsbDogI2E1YjVjMTtcclxuICAgICAgd2lkdGg6IDIuNXJlbTtcclxuICAgICAgaGVpZ2h0OiAyLjVyZW07XHJcbiAgICB9XHJcblxyXG4gICAgJjpsYXN0LWNoaWxkIHtcclxuICAgICAgbWFyZ2luLXRvcDogYXV0bztcclxuICAgIH1cclxuICB9XHJcbn1cclxuXHJcbi5jaGF0cyB7XHJcbiAgYmFja2dyb3VuZC1jb2xvcjogIzQzNGM1NztcclxuICBjb2xvcjogI2ZmZjtcclxuXHJcbiAgJl9fdGl0bGUge1xyXG4gICAgdGV4dC1hbGlnbjogY2VudGVyO1xyXG4gICAgcGFkZGluZzogMXJlbSAwO1xyXG4gIH1cclxuICAuY2hhdC1wcmV2aWV3IHtcclxuICAgIGN1cnNvcjogcG9pbnRlcjtcclxuICAgIHBhZGRpbmc6IDFyZW07XHJcbiAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAgYWxpZ24taXRlbXM6IGNlbnRlcjtcclxuICAgIHRyYW5zaXRpb246IGJhY2tncm91bmQtY29sb3IgMC4ycztcclxuXHJcbiAgICAmOmhvdmVyLFxyXG4gICAgJi0tYWN0aXZlIHtcclxuICAgICAgYmFja2dyb3VuZC1jb2xvcjogIzVkNjk3NztcclxuICAgIH1cclxuXHJcbiAgICAmOmFjdGl2ZSB7XHJcbiAgICAgIGJhY2tncm91bmQtY29sb3I6ICM1MDViNjg7XHJcbiAgICB9XHJcblxyXG4gICAgJl9fYXZhdGFyIHtcclxuICAgICAgaGVpZ2h0OiA0cmVtO1xyXG4gICAgICBib3JkZXItcmFkaXVzOiA1MCU7XHJcbiAgICAgIG1hcmdpbi1yaWdodDogMS41cmVtO1xyXG4gICAgfVxyXG5cclxuICAgICZfX3RleHQge1xyXG4gICAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uO1xyXG4gICAgfVxyXG5cclxuICAgICZfX2JvdG5hbWUge1xyXG4gICAgICBmb250LXNpemU6IDEuN3JlbTtcclxuICAgIH1cclxuXHJcbiAgICAmX19tZXNzYWdlIHtcclxuICAgICAgZm9udC1zaXplOiAxLjVyZW07XHJcbiAgICB9XHJcbiAgfVxyXG59XHJcblxyXG4uY2hhdCB7XHJcbiAgYmFja2dyb3VuZC1jb2xvcjogI2YyZjdmNztcclxuICBjb2xvcjogIzg4ODg4ODtcclxuXHJcbiAgZGlzcGxheTogZ3JpZDtcclxuICBncmlkLXRlbXBsYXRlLXJvd3M6IGF1dG8gNDcuNXJlbSBhdXRvO1xyXG5cclxuICAmX19ib3RuYW1lIHtcclxuICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7XHJcbiAgICBqdXN0aWZ5LXNlbGY6IGNlbnRlcjtcclxuXHJcbiAgICBib3JkZXItYm90dG9tOiAycHggc29saWQgcmdiYSgxODcsIDE4MiwgMTgyLCAwLjMyOSk7XHJcbiAgICBwYWRkaW5nOiAxcmVtO1xyXG4gIH1cclxuXHJcbiAgLm1lc3NhZ2VzIHtcclxuICAgIHBhZGRpbmc6IDFyZW07XHJcbiAgICBvdmVyZmxvdzogYXV0bztcclxuICAgIHBvc2l0aW9uOiByZWxhdGl2ZTtcclxuICAgIGJvdHRvbTogMDtcclxuXHJcbiAgICAubWVzc2FnZS1ib3gge1xyXG4gICAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAgICBhbGlnbi1pdGVtczogY2VudGVyO1xyXG5cclxuICAgICAgJjpub3QoOmxhc3QtY2hpbGQpIHtcclxuICAgICAgICBtYXJnaW4tYm90dG9tOiAxLjI1cmVtO1xyXG4gICAgICB9XHJcblxyXG4gICAgICAmLS11c2VyIHtcclxuICAgICAgICBmbGV4LWRpcmVjdGlvbjogcm93LXJldmVyc2U7XHJcbiAgICAgIH1cclxuXHJcbiAgICAgICZfX3BpY3R1cmUge1xyXG4gICAgICAgIGhlaWdodDogNXJlbTtcclxuICAgICAgICBib3JkZXItcmFkaXVzOiA1MCU7XHJcblxyXG4gICAgICAgICYtLWJvdCB7XHJcbiAgICAgICAgICBtYXJnaW4tcmlnaHQ6IDEuNXJlbTtcclxuICAgICAgICB9XHJcblxyXG4gICAgICAgICYtLXVzZXIge1xyXG4gICAgICAgICAgbWFyZ2luLWxlZnQ6IDEuNXJlbTtcclxuICAgICAgICB9XHJcbiAgICAgIH1cclxuXHJcbiAgICAgICZfX21lc3NhZ2Uge1xyXG4gICAgICAgIGJveC1zaGFkb3c6IDBweCA2cHggMjNweCAtNnB4IHJnYmEoMCwgMCwgMCwgMC4yNCk7XHJcbiAgICAgICAgZm9udC1zaXplOiAxLjVyZW07XHJcbiAgICAgICAgcGFkZGluZzogMXJlbTtcclxuICAgICAgICBtYXgtd2lkdGg6IGNhbGMoMTAwJSAtICgyICogOHJlbSkpO1xyXG4gICAgICAgIHdvcmQtYnJlYWs6IGJyZWFrLWFsbDtcclxuXHJcbiAgICAgICAgJi0tYm90IHtcclxuICAgICAgICAgIGJhY2tncm91bmQtY29sb3I6ICNmZmY7XHJcbiAgICAgICAgfVxyXG5cclxuICAgICAgICAmLS11c2VyIHtcclxuICAgICAgICAgIGJhY2tncm91bmQtY29sb3I6ICM1NGQzOGE7XHJcbiAgICAgICAgICBjb2xvcjogI2ZmZjtcclxuICAgICAgICB9XHJcbiAgICAgIH1cclxuICAgIH1cclxuICB9XHJcblxyXG4gIC50eXBlciB7XHJcbiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjZmZmO1xyXG5cclxuICAgIGRpc3BsYXk6IGZsZXg7XHJcbiAgICBhbGlnbi1pdGVtczogY2VudGVyO1xyXG5cclxuICAgICZfX2lucHV0IHtcclxuICAgICAgYm9yZGVyOiBub25lO1xyXG4gICAgICBvdXRsaW5lOiBub25lO1xyXG4gICAgICBmb250LXNpemU6IDEuOHJlbTtcclxuICAgICAgZmxleDogMCAwIDkwJTtcclxuICAgICAgcGFkZGluZzogMS41cmVtIDFyZW07XHJcbiAgICB9XHJcblxyXG4gICAgJl9fYnV0dG9uIHtcclxuICAgICAgY3Vyc29yOiBwb2ludGVyO1xyXG4gICAgICBmaWxsOiAjYTViNWMxO1xyXG4gICAgICB3aWR0aDogMi4yNXJlbTtcclxuICAgICAgaGVpZ2h0OiAyLjI1cmVtO1xyXG4gICAgICBmbGV4OiAwIDAgMTAlO1xyXG4gICAgICB0cmFuc2l0aW9uOiBmaWxsIDAuMnM7XHJcblxyXG4gICAgICAmOmhvdmVyIHtcclxuICAgICAgICBmaWxsOiAjNzQ3Zjg4O1xyXG4gICAgICB9XHJcbiAgICB9XHJcbiAgfVxyXG59XHJcbiIsIi5hcHBsaWNhdGlvbi1ncmlkIHtcbiAgZGlzcGxheTogZ3JpZDtcbiAgZ3JpZC10ZW1wbGF0ZS1jb2x1bW5zOiAxMXJlbSAyNy41cmVtIDg1cmVtO1xufVxuXG4uc2lkZWJhciB7XG4gIGJhY2tncm91bmQtY29sb3I6ICMzMDM4NDE7XG4gIGRpc3BsYXk6IGZsZXg7XG4gIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47XG59XG4uc2lkZWJhciAudXNlci1ib3gge1xuICBjb2xvcjogI2ZmZjtcbiAgcGFkZGluZzogMS41cmVtIDA7XG4gIGRpc3BsYXk6IGZsZXg7XG4gIGFsaWduLWl0ZW1zOiBjZW50ZXI7XG4gIGp1c3RpZnktY29udGVudDogY2VudGVyO1xuICBmbGV4LWRpcmVjdGlvbjogY29sdW1uO1xufVxuLnNpZGViYXIgLnVzZXItYm94X19hdmF0YXIge1xuICBib3JkZXItcmFkaXVzOiA1MCU7XG4gIGhlaWdodDogNC41cmVtO1xuICBtYXJnaW4tYm90dG9tOiAwLjc1cmVtO1xufVxuLnNpZGViYXIgLnVzZXItYm94X191c2VybmFtZSB7XG4gIGZvbnQtc2l6ZTogMS40cmVtO1xufVxuLnNpZGViYXIgLm9wdGlvbiB7XG4gIGN1cnNvcjogcG9pbnRlcjtcbiAgcGFkZGluZzogMXJlbSAwO1xuICBkaXNwbGF5OiBmbGV4O1xuICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjtcbiAgYWxpZ24taXRlbXM6IGNlbnRlcjtcbiAgdHJhbnNpdGlvbjogYmFja2dyb3VuZC1jb2xvciAwLjJzO1xufVxuLnNpZGViYXIgLm9wdGlvbjpob3ZlciB7XG4gIGJhY2tncm91bmQtY29sb3I6ICM0MzRjNTc7XG59XG4uc2lkZWJhciAub3B0aW9uOmFjdGl2ZSB7XG4gIGJhY2tncm91bmQtY29sb3I6ICM0YjU1NjE7XG59XG4uc2lkZWJhciAub3B0aW9uX19pY29uIHtcbiAgZmlsbDogI2E1YjVjMTtcbiAgd2lkdGg6IDIuNXJlbTtcbiAgaGVpZ2h0OiAyLjVyZW07XG59XG4uc2lkZWJhciAub3B0aW9uOmxhc3QtY2hpbGQge1xuICBtYXJnaW4tdG9wOiBhdXRvO1xufVxuXG4uY2hhdHMge1xuICBiYWNrZ3JvdW5kLWNvbG9yOiAjNDM0YzU3O1xuICBjb2xvcjogI2ZmZjtcbn1cbi5jaGF0c19fdGl0bGUge1xuICB0ZXh0LWFsaWduOiBjZW50ZXI7XG4gIHBhZGRpbmc6IDFyZW0gMDtcbn1cbi5jaGF0cyAuY2hhdC1wcmV2aWV3IHtcbiAgY3Vyc29yOiBwb2ludGVyO1xuICBwYWRkaW5nOiAxcmVtO1xuICBkaXNwbGF5OiBmbGV4O1xuICBhbGlnbi1pdGVtczogY2VudGVyO1xuICB0cmFuc2l0aW9uOiBiYWNrZ3JvdW5kLWNvbG9yIDAuMnM7XG59XG4uY2hhdHMgLmNoYXQtcHJldmlldzpob3ZlciwgLmNoYXRzIC5jaGF0LXByZXZpZXctLWFjdGl2ZSB7XG4gIGJhY2tncm91bmQtY29sb3I6ICM1ZDY5Nzc7XG59XG4uY2hhdHMgLmNoYXQtcHJldmlldzphY3RpdmUge1xuICBiYWNrZ3JvdW5kLWNvbG9yOiAjNTA1YjY4O1xufVxuLmNoYXRzIC5jaGF0LXByZXZpZXdfX2F2YXRhciB7XG4gIGhlaWdodDogNHJlbTtcbiAgYm9yZGVyLXJhZGl1czogNTAlO1xuICBtYXJnaW4tcmlnaHQ6IDEuNXJlbTtcbn1cbi5jaGF0cyAuY2hhdC1wcmV2aWV3X190ZXh0IHtcbiAgZGlzcGxheTogZmxleDtcbiAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjtcbn1cbi5jaGF0cyAuY2hhdC1wcmV2aWV3X19ib3RuYW1lIHtcbiAgZm9udC1zaXplOiAxLjdyZW07XG59XG4uY2hhdHMgLmNoYXQtcHJldmlld19fbWVzc2FnZSB7XG4gIGZvbnQtc2l6ZTogMS41cmVtO1xufVxuXG4uY2hhdCB7XG4gIGJhY2tncm91bmQtY29sb3I6ICNmMmY3Zjc7XG4gIGNvbG9yOiAjODg4ODg4O1xuICBkaXNwbGF5OiBncmlkO1xuICBncmlkLXRlbXBsYXRlLXJvd3M6IGF1dG8gNDcuNXJlbSBhdXRvO1xufVxuLmNoYXRfX2JvdG5hbWUge1xuICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlO1xuICBqdXN0aWZ5LXNlbGY6IGNlbnRlcjtcbiAgYm9yZGVyLWJvdHRvbTogMnB4IHNvbGlkIHJnYmEoMTg3LCAxODIsIDE4MiwgMC4zMjkpO1xuICBwYWRkaW5nOiAxcmVtO1xufVxuLmNoYXQgLm1lc3NhZ2VzIHtcbiAgcGFkZGluZzogMXJlbTtcbiAgb3ZlcmZsb3c6IGF1dG87XG4gIHBvc2l0aW9uOiByZWxhdGl2ZTtcbiAgYm90dG9tOiAwO1xufVxuLmNoYXQgLm1lc3NhZ2VzIC5tZXNzYWdlLWJveCB7XG4gIGRpc3BsYXk6IGZsZXg7XG4gIGFsaWduLWl0ZW1zOiBjZW50ZXI7XG59XG4uY2hhdCAubWVzc2FnZXMgLm1lc3NhZ2UtYm94Om5vdCg6bGFzdC1jaGlsZCkge1xuICBtYXJnaW4tYm90dG9tOiAxLjI1cmVtO1xufVxuLmNoYXQgLm1lc3NhZ2VzIC5tZXNzYWdlLWJveC0tdXNlciB7XG4gIGZsZXgtZGlyZWN0aW9uOiByb3ctcmV2ZXJzZTtcbn1cbi5jaGF0IC5tZXNzYWdlcyAubWVzc2FnZS1ib3hfX3BpY3R1cmUge1xuICBoZWlnaHQ6IDVyZW07XG4gIGJvcmRlci1yYWRpdXM6IDUwJTtcbn1cbi5jaGF0IC5tZXNzYWdlcyAubWVzc2FnZS1ib3hfX3BpY3R1cmUtLWJvdCB7XG4gIG1hcmdpbi1yaWdodDogMS41cmVtO1xufVxuLmNoYXQgLm1lc3NhZ2VzIC5tZXNzYWdlLWJveF9fcGljdHVyZS0tdXNlciB7XG4gIG1hcmdpbi1sZWZ0OiAxLjVyZW07XG59XG4uY2hhdCAubWVzc2FnZXMgLm1lc3NhZ2UtYm94X19tZXNzYWdlIHtcbiAgYm94LXNoYWRvdzogMHB4IDZweCAyM3B4IC02cHggcmdiYSgwLCAwLCAwLCAwLjI0KTtcbiAgZm9udC1zaXplOiAxLjVyZW07XG4gIHBhZGRpbmc6IDFyZW07XG4gIG1heC13aWR0aDogY2FsYygxMDAlIC0gKDIgKiA4cmVtKSk7XG4gIHdvcmQtYnJlYWs6IGJyZWFrLWFsbDtcbn1cbi5jaGF0IC5tZXNzYWdlcyAubWVzc2FnZS1ib3hfX21lc3NhZ2UtLWJvdCB7XG4gIGJhY2tncm91bmQtY29sb3I6ICNmZmY7XG59XG4uY2hhdCAubWVzc2FnZXMgLm1lc3NhZ2UtYm94X19tZXNzYWdlLS11c2VyIHtcbiAgYmFja2dyb3VuZC1jb2xvcjogIzU0ZDM4YTtcbiAgY29sb3I6ICNmZmY7XG59XG4uY2hhdCAudHlwZXIge1xuICBiYWNrZ3JvdW5kLWNvbG9yOiAjZmZmO1xuICBkaXNwbGF5OiBmbGV4O1xuICBhbGlnbi1pdGVtczogY2VudGVyO1xufVxuLmNoYXQgLnR5cGVyX19pbnB1dCB7XG4gIGJvcmRlcjogbm9uZTtcbiAgb3V0bGluZTogbm9uZTtcbiAgZm9udC1zaXplOiAxLjhyZW07XG4gIGZsZXg6IDAgMCA5MCU7XG4gIHBhZGRpbmc6IDEuNXJlbSAxcmVtO1xufVxuLmNoYXQgLnR5cGVyX19idXR0b24ge1xuICBjdXJzb3I6IHBvaW50ZXI7XG4gIGZpbGw6ICNhNWI1YzE7XG4gIHdpZHRoOiAyLjI1cmVtO1xuICBoZWlnaHQ6IDIuMjVyZW07XG4gIGZsZXg6IDAgMCAxMCU7XG4gIHRyYW5zaXRpb246IGZpbGwgMC4ycztcbn1cbi5jaGF0IC50eXBlcl9fYnV0dG9uOmhvdmVyIHtcbiAgZmlsbDogIzc0N2Y4ODtcbn0iXX0= */"

/***/ }),

/***/ "./src/app/app.component.ts":
/*!**********************************!*\
  !*** ./src/app/app.component.ts ***!
  \**********************************/
/*! exports provided: AppComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppComponent", function() { return AppComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");



var AppComponent = /** @class */ (function () {
    //heders = new HttpHeaders();
    //headers = this.heders.set('Content-Type', 'application/json');
    function AppComponent(http) {
        this.http = http;
        this.userPicture = "assets/img/user.jpg";
        this.botPicture = "assets/img/bot2.png";
        this.url = "http://localhost:3000/api2";
    }
    AppComponent.prototype.ngOnInit = function () {
        this.messages = [
            { id: 0, owner: "User", body: "Hello.." },
            { id: 0, owner: "Bot", body: "How are you doing? :)" }
        ];
    };
    AppComponent.prototype.onSendMessage = function (input) {
        var _this = this;
        if (input.value) {
            this.messages.push({ id: 0, owner: "User", body: input.value });
            var postData = { "text": input.value };
            var resData_1;
            this.http.post(this.url, postData).toPromise().then(function (data) {
                resData_1 = data['text'];
            });
            setTimeout(function () {
                _this.messages.push({ id: 0, owner: "Bot", body: "..." });
                setTimeout(function () {
                    _this.messages.pop();
                    _this.messages.push({
                        id: 0,
                        owner: "Bot",
                        body: resData_1
                    });
                }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
            }, 750);
        }
    };
    AppComponent.ctorParameters = function () { return [
        { type: _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"] }
    ]; };
    AppComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: "app-root",
            template: __webpack_require__(/*! raw-loader!./app.component.html */ "./node_modules/raw-loader/index.js!./src/app/app.component.html"),
            styles: [__webpack_require__(/*! ./app.component.scss */ "./src/app/app.component.scss")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "./src/app/app.module.ts":
/*!*******************************!*\
  !*** ./src/app/app.module.ts ***!
  \*******************************/
/*! exports provided: AppModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppModule", function() { return AppModule; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser */ "./node_modules/@angular/platform-browser/fesm5/platform-browser.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _app_routing_module__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./app-routing.module */ "./src/app/app-routing.module.ts");
/* harmony import */ var _app_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./app.component */ "./src/app/app.component.ts");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");






var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_2__["NgModule"])({
            declarations: [
                _app_component__WEBPACK_IMPORTED_MODULE_4__["AppComponent"]
            ],
            imports: [
                _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__["BrowserModule"],
                _app_routing_module__WEBPACK_IMPORTED_MODULE_3__["AppRoutingModule"],
                _angular_common_http__WEBPACK_IMPORTED_MODULE_5__["HttpClientModule"]
            ],
            providers: [],
            bootstrap: [_app_component__WEBPACK_IMPORTED_MODULE_4__["AppComponent"]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/environments/environment.ts":
/*!*****************************************!*\
  !*** ./src/environments/environment.ts ***!
  \*****************************************/
/*! exports provided: environment */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "environment", function() { return environment; });
// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
var environment = {
    production: false
};
/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.


/***/ }),

/***/ "./src/main.ts":
/*!*********************!*\
  !*** ./src/main.ts ***!
  \*********************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser-dynamic */ "./node_modules/@angular/platform-browser-dynamic/fesm5/platform-browser-dynamic.js");
/* harmony import */ var _app_app_module__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./app/app.module */ "./src/app/app.module.ts");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./environments/environment */ "./src/environments/environment.ts");




if (_environments_environment__WEBPACK_IMPORTED_MODULE_3__["environment"].production) {
    Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["enableProdMode"])();
}
Object(_angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__["platformBrowserDynamic"])().bootstrapModule(_app_app_module__WEBPACK_IMPORTED_MODULE_2__["AppModule"])
    .catch(function (err) { return console.error(err); });


/***/ }),

/***/ 0:
/*!***************************!*\
  !*** multi ./src/main.ts ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! C:\Users\LoLER\OneDrive - Universidad Nacional de Costa Rica\Documentos\Proyecto-Paradigmas-G03-3pm\Angular SPA\src\main.ts */"./src/main.ts");


/***/ })

},[[0,"runtime","vendor"]]]);
//# sourceMappingURL=main-es5.js.map