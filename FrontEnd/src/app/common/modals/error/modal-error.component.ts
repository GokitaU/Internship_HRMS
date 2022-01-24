import { Component, Input } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-modal-error',
  templateUrl: './modal-error.component.html',
  styleUrls: ['./modal-error.component.scss']
})

export class ModalErrorComponent {

  @Input() modalTitle: any;
  @Input() modalContent: any;
  @Input() buttonTitle: any;

  constructor(public activeModal: NgbActiveModal) {
  }

  action() {
    this.activeModal.close();
  }
}
