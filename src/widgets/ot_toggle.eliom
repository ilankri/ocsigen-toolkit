(* Ocsigen
 * http://www.ocsigen.org
 * Copyright (C) 2015
 * Vasilis Papavasileiou
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

{shared{
module Html5 = Eliom_content.Html5
open Html5.F
}}

{client{

type t = T_Up | T_Down

let display_toggle
    ?up_txt:(up_txt = "up")
    ?down_txt:(down_txt = "down")
    (f : (t -> unit) Eliom_lib.client_value) =
  function
  | T_Up ->
    div ~a:[a_class ["ot-toggle"]]
      [div ~a:[a_class ["ot-active"; "ot-up"]]
         [pcdata up_txt];
       div ~a:[a_class ["ot-inactive"; "ot-down"];
               a_onclick (fun _ -> f T_Down) ]
         [pcdata down_txt]]
  | T_Down ->
    div ~a:[a_class ["ot-toggle"]]
      [div ~a:[a_class ["ot-inactive"; "ot-up"];
               a_onclick (fun _ -> f T_Up) ]
         [pcdata up_txt];
       div ~a:[a_class ["ot-active"; "ot-down"]]
         [pcdata down_txt]]

let is_up = function
  | T_Up ->
    true
  | T_Down ->
    false

let make ?init_up:(init_up = false) ?up_txt ?down_txt () =
  let e, f =
    (if init_up then T_Up else T_Down) |>
    Eliom_csreact.React.S.create
  in
  Eliom_content.Html5.R.node
    (Eliom_csreact.React.S.map
       (display_toggle f ?up_txt ?down_txt)
       e),
  Eliom_csreact.React.S.map is_up e

}} ;;

{server{

    let make ?init_up ?up_txt ?down_txt () =
      let e_f =
        {[> Html5_types.div ] Eliom_content.Html5.F.elt *
         bool React.signal{
           make
             ?init_up:%init_up
             ?up_txt:%up_txt
             ?down_txt:%down_txt
             () }}
      in
      Eliom_content.Html5.C.node {{ fst %e_f }},
      {bool React.signal{ snd %e_f }}

}}
