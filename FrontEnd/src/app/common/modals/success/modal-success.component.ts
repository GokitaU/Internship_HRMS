import { Component, OnInit, Input } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { Router } from '@angular/router';

@Component({
    selector: 'app-modal-success',
    templateUrl: './modal-success.component.html',
    styleUrls: ['./modal-success.component.scss']
})
export class ModalSuccessComponent implements OnInit {

    @Input() modalTitle: any;
    @Input() modalContent: any;
    @Input() optionModalContent: any;
    @Input() buttonTitle: any;
    @Input() url: any;

    constructor(public activeModal: NgbActiveModal, private _router: Router) {
    }

    ngOnInit() {
    }

    reLoad() {
        if (this.url != null) {
            this.activeModal.dismiss(this.url);
            this._router.navigateByUrl(this.url);
        } else {
            this.activeModal.close();
        }
    }
}
